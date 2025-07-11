import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class AdMobAdUnitIds {
  // Production Ad Unit IDs
  static const String banner = 'ca-app-pub-9589008379442992/8551664977';
  static const String interstitial = 'ca-app-pub-9589008379442992/7848957396';
  static const String rewarded = 'ca-app-pub-9589008379442992/9864746643';
  // Add more if needed

  // Demo/Test Ad Unit IDs (from Google)
  static const String testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String testRewarded = 'ca-app-pub-3940256099942544/5224354917';

  static String get bannerId => kReleaseMode ? banner : testBanner;
  static String get interstitialId => kReleaseMode ? interstitial : testInterstitial;
  static String get rewardedId => kReleaseMode ? rewarded : testRewarded;
}

class InterstitialAdManager {
  static final InterstitialAdManager instance = InterstitialAdManager._internal();
  factory InterstitialAdManager() => instance;
  InterstitialAdManager._internal();

  static const int _clickLimit = 3; // Kaç tıklamada bir reklam gösterilecek
  int _clickCount = 0;
  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;

  void registerClick({VoidCallback? onAdShowed, VoidCallback? onAdClosed}) {
    _clickCount++;
    if (_clickCount >= _clickLimit) {
      _showInterstitialAd(onAdShowed: onAdShowed, onAdClosed: onAdClosed);
      _clickCount = 0;
    }
  }

  void _loadInterstitialAd() {
    if (_isAdLoading || _interstitialAd != null) return;
    _isAdLoading = true;
    InterstitialAd.load(
      adUnitId: AdMobAdUnitIds.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isAdLoading = false;
        },
      ),
    );
  }

  void _showInterstitialAd({VoidCallback? onAdShowed, VoidCallback? onAdClosed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          if (onAdShowed != null) onAdShowed();
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitialAd();
          if (onAdClosed != null) onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      _loadInterstitialAd();
    }
  }

  void initialize() {
    _loadInterstitialAd();
  }
} 