
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppAdBanner extends StatefulWidget {
  const AppAdBanner({super.key});

  @override
  State<AppAdBanner> createState() => _AppAdBannerState();
}

class _AppAdBannerState extends State<AppAdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;

  static const String _adUnitId =
      'ca-app-pub-3940256099942544/9214589741';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoading && _bannerAd == null && !_isLoaded) {
      _loadBannerAd();
    }
  }

  Future<void> _loadBannerAd() async {
    _isLoading = true;

    final width = MediaQuery.sizeOf(context).width.truncate();

    final size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );

    if (!mounted || size == null) {
      _isLoading = false;
      return;
    }

    final banner = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner Ad failed: ${error.message}');

          ad.dispose();

          if (!mounted) return;

          setState(() {
            _bannerAd = null;
            _isLoaded = false;
            _isLoading = false;
          });
        },
      ),
    );

    _bannerAd = banner;

    await banner.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
