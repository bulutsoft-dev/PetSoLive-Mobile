import 'package:hive/hive.dart';
import '../models/lost_pet_ad_dto.dart';

class LostPetAdLocalDataSource {
  static const String boxName = 'lostPetAdsBox';

  Future<void> saveAds(List<LostPetAdDto> ads) async {
    final box = await Hive.openBox<LostPetAdDto>(boxName);
    await box.clear();
    await box.addAll(ads);
  }

  Future<List<LostPetAdDto>> getAds() async {
    final box = await Hive.openBox<LostPetAdDto>(boxName);
    return box.values.toList();
  }
} 