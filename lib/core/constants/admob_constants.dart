import 'package:flutter/foundation.dart';

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