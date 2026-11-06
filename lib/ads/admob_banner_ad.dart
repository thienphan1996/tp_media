import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:tp_media/network/internet_manager.dart';

class AdmobBannerAd extends StatefulWidget {
  const AdmobBannerAd(this.unitId, {this.isEnableAd = true, super.key});

  final String unitId;
  final bool isEnableAd;

  static var isTestMode = false;

  @override
  State<AdmobBannerAd> createState() => _AdmobBannerAdState();
}

class _AdmobBannerAdState extends State<AdmobBannerAd> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isEnableAd) return const SizedBox.shrink();

    final orientation = MediaQuery.orientationOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            (constraints.hasBoundedWidth
                    ? constraints.maxWidth
                    : MediaQuery.sizeOf(context).width)
                .floor();
        if (width <= 0) return const SizedBox.shrink();

        if (AdmobBannerAd.isTestMode) {
          return Image.asset(
            'assets/tp_media_banner.png',
            package: 'tp_media',
            width: width.toDouble(),
            height: width / 7,
            fit: BoxFit.fill,
          );
        }

        // A new configuration owns a new state. Disposing the old state also
        // invalidates pending size lookups, callbacks, and retries.
        return _AdaptiveBanner(
          key: ValueKey((widget.unitId, width, orientation)),
          unitId: widget.unitId,
          width: width,
          orientation: orientation,
        );
      },
    );
  }
}

class _AdaptiveBanner extends StatefulWidget {
  const _AdaptiveBanner({
    required this.unitId,
    required this.width,
    required this.orientation,
    super.key,
  });

  final String unitId;
  final int width;
  final Orientation orientation;

  @override
  State<_AdaptiveBanner> createState() => _AdaptiveBannerState();
}

class _AdaptiveBannerState extends State<_AdaptiveBanner>
    with WidgetsBindingObserver {
  static const _maxRetries = 5;

  BannerAd? _ad;
  bool _isLoaded = false;
  bool _isLoading = false;
  int _retryCount = 0;
  Timer? _retryTimer;
  StreamSubscription<InternetStatus>? _connectionSubscription;
  InternetStatus? _connectionStatus;

  bool get _isInForeground {
    final state = WidgetsBinding.instance.lifecycleState;
    return state == null || state == AppLifecycleState.resumed;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_loadAd());
  }

  Future<void> _loadAd() async {
    if (!mounted ||
        _isLoading ||
        _ad != null ||
        !_isInForeground ||
        _connectionStatus == InternetStatus.disconnected) {
      return;
    }

    _retryTimer?.cancel();
    _retryTimer = null;
    _isLoading = true;
    BannerAd? loadingAd;
    try {
      final size =
          await AdSize.getLargeAnchoredAdaptiveBannerAdSizeWithOrientation(
            widget.orientation,
            widget.width,
          );
      if (!mounted) return;
      if (size == null) {
        _onLoadFailed(null, 'Adaptive banner size is unavailable.');
        return;
      }

      loadingAd = BannerAd(
        adUnitId: widget.unitId,
        size: size,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (!mounted || !identical(ad, _ad)) return;
            _retryTimer?.cancel();
            _retryTimer = null;
            _retryCount = 0;
            _stopWatchingConnection();
            setState(() {
              _isLoading = false;
              _isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) => _onLoadFailed(ad, error),
        ),
      );
      _ad = loadingAd;
      await loadingAd.load();
    } catch (error) {
      _onLoadFailed(loadingAd, error);
    }
  }

  void _onLoadFailed(Ad? ad, Object error) {
    if (!mounted || (ad != null && !identical(ad, _ad))) return;
    debugPrint('BannerAd failed to load: $error');

    // Keep a displayed banner alive so its SDK-managed refresh can recover.
    if (_isLoaded) return;

    _ad = null;
    _isLoading = false;
    if (ad != null) unawaited(ad.dispose());
    _watchConnection();
    _scheduleRetry();
  }

  void _scheduleRetry() {
    if (!mounted ||
        _isLoading ||
        _ad != null ||
        !_isInForeground ||
        _retryTimer != null ||
        _retryCount >= _maxRetries ||
        _connectionStatus == InternetStatus.disconnected) {
      return;
    }

    // Retry initial failures at 5, 10, 20, 40, and 80 seconds. Successfully
    // loaded banners use AdMob's refresh settings instead of a local timer.
    final delay = Duration(seconds: 5 * (1 << _retryCount));
    _retryCount++;
    _retryTimer = Timer(delay, () {
      _retryTimer = null;
      unawaited(_loadAd());
    });
  }

  void _watchConnection() {
    _connectionSubscription ??= InternetManager.instance.onStatusChange.listen((
      status,
    ) {
      if (!mounted) return;
      final previousStatus = _connectionStatus;
      _connectionStatus = status;
      if (status == InternetStatus.disconnected) {
        _retryTimer?.cancel();
        _retryTimer = null;
      } else if (previousStatus == InternetStatus.disconnected) {
        _retryCount = 0;
        unawaited(_loadAd());
      } else {
        _scheduleRetry();
      }
    });
  }

  void _stopWatchingConnection() {
    final subscription = _connectionSubscription;
    _connectionSubscription = null;
    _connectionStatus = null;
    if (subscription != null) unawaited(subscription.cancel());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_ad == null && !_isLoading) {
        _retryCount = 0;
        unawaited(_loadAd());
      }
    } else {
      _retryTimer?.cancel();
      _retryTimer = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _retryTimer?.cancel();
    _stopWatchingConnection();
    final ad = _ad;
    _ad = null;
    if (ad != null) {
      if (_isLoaded) {
        // Let the child AdWidget unregister its platform view before removing
        // the ad from the plugin's instance manager.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(ad.dispose());
        });
      } else {
        unawaited(ad.dispose());
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_isLoaded || ad == null) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(key: ValueKey(ad), ad: ad),
    );
  }
}
