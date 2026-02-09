import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tp_media/network/internet_manager.dart';

class AdmobNativeAd extends StatefulWidget {
  const AdmobNativeAd(
    this.unitId, {
    this.isEnableAd = true,
    this.isSmall = false,
    super.key,
    this.ctaColor = Colors.blue,
    this.excludePadding = 0,
  });

  final String unitId;
  final bool isEnableAd;
  final Color ctaColor;
  final bool isSmall;
  final double excludePadding;

  @override
  State<AdmobNativeAd> createState() => _AdmobNativeAdState();
}

class _AdmobNativeAdState extends State<AdmobNativeAd> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEnableAd) {
      _loadAd();
    }
  }

  @override
  void didUpdateWidget(AdmobNativeAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnableAd != oldWidget.isEnableAd ||
        widget.unitId != oldWidget.unitId) {
      if (widget.isEnableAd) {
        _loadAd();
      } else {
        _disposeAd();
      }
    }
  }

  void _disposeAd() {
    _nativeAd?.dispose();
    _nativeAd = null;
    if (mounted) {
      setState(() {
        _isLoaded = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAd() async {
    if (_isLoading || !widget.isEnableAd) return;

    final bool isOnline = await InternetManager.instance.isOnline;
    if (!isOnline) return;

    if (!mounted) return;

    _disposeAd();

    setState(() {
      _isLoading = true;
    });

    _nativeAd = NativeAd(
      adUnitId: widget.unitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _nativeAd = ad as NativeAd;
            _isLoaded = true;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('NativeAd failed to load: $error');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isLoading = false;
              _isLoaded = false;
              _nativeAd = null;
            });
          }
        },
        onAdImpression: (ad) => debugPrint('NativeAd impression.'),
        onAdClicked: (ad) => debugPrint('NativeAd clicked.'),
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.isSmall ? TemplateType.small : TemplateType.medium,
        cornerRadius: 12.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: widget.ctaColor,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),
      ),
    );

    await _nativeAd!.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnableAd) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded || _nativeAd == null) {
      // Returning an empty Box but perhaps with a tiny bit of height if we want to reserve space
      // For now, we keep it as shrink to avoid empty gaps if loading fails
      return const SizedBox.shrink();
    }

    final adAspectRatioMedium = 370 / (370 - widget.excludePadding * 2);
    final adAspectRatioSmall = 91 / (355 - widget.excludePadding * 2);

    return AspectRatio(
      aspectRatio:
          widget.isSmall ? (1 / adAspectRatioSmall) : (1 / adAspectRatioMedium),
      child: AdWidget(ad: _nativeAd!),
    );
  }
}
