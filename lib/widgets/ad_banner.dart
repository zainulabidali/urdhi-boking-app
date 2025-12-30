import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Reusable bottom banner advertisement widget using Google AdMob
///
/// This widget displays a banner ad at the bottom of screens.
/// - Uses test ads during development (BannerAd.testAdUnitId)
/// - Switch to live ad unit ID after AdMob approval
/// - Handles ad loading states and errors gracefully
/// - Respects safe areas for proper display on all devices
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _hasError = false;

  // Ad Unit IDs
  // TODO: Replace with live ad unit ID after AdMob approval
  // Live Banner Ad Unit ID: ca-app-pub-3072484265637122/3494071535
  static const String _liveBannerAdUnitId =
      'ca-app-pub-3072484265637122/3494071535';

  // Test ad unit ID for Android (provided by Google for testing)
  static const String _testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      // Use test ad unit ID during development
      // Switch to _liveBannerAdUnitId for production after AdMob approval
      adUnitId:
          _testBannerAdUnitId, // Change to _liveBannerAdUnitId for production
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _hasError = false;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad if it fails to load
          ad.dispose();
          if (mounted) {
            setState(() {
              _isLoaded = false;
              _hasError = true;
            });
          }
          // Log error for debugging (optional)
          debugPrint('Banner ad failed to load: $error');
        },
        onAdOpened: (_) {
          // Ad opened - user clicked on ad
          debugPrint('Banner ad opened');
        },
        onAdClosed: (_) {
          // Ad closed - user returned from ad
          debugPrint('Banner ad closed');
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 56, // Standard banner height
        width: double.infinity,
        child: _isLoaded && _bannerAd != null
            ? AdWidget(ad: _bannerAd!)
            : Container(
                color: Colors.grey.shade100,
                alignment: Alignment.center,
                child: Text(
                  _hasError ? 'Ad unavailable' : 'Banner Ad',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
