import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  /// Load another ad, disposing of the current ad if there is one.
  Future<void> _loadAd() async {
    if (!widget.isEnableAd ||
        await InternetManager.instance.isOnline == false) {
      return;
    }

    if (!mounted) {
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width.truncate();
    _anchoredAdaptiveAd?.dispose();

    setState(() {
      _anchoredAdaptiveAd = null;
      _isLoaded = false;
    });

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          screenWidth,
        );

    if (size == null) {
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: widget.unitId,
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  /// Gets a widget containing the ad, if one is loaded.
  ///
  /// Returns an empty container if no ad is loaded, or the orientation
  /// has changed. Also loads a new ad if the orientation changes.
  Widget _getAdWidget() {
    if (!widget.isEnableAd) {
      return SizedBox.shrink();
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _anchoredAdaptiveAd != null &&
            _isLoaded) {
          return Container(
            color: Colors.white,
            width: _anchoredAdaptiveAd!.size.width.toDouble(),
            height: _anchoredAdaptiveAd!.size.height.toDouble(),
            child:
                !AdmobBannerAd.isTestMode
                    ? AdWidget(ad: _anchoredAdaptiveAd!)
                    : Image.asset(
                      'assets/tp_media_banner.png',
                      package: 'tp_media',
                      width: _anchoredAdaptiveAd!.size.width.toDouble(),
                      height: _anchoredAdaptiveAd!.size.width.toDouble() / 7,
                      fit: BoxFit.fill,
                    ),
          );
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    _anchoredAdaptiveAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white, child: _getAdWidget());
  }
}
