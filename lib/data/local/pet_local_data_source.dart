import 'package:hive/hive.dart';
import '../models/pet_dto.dart';

class PetLocalDataSource {
  static const String boxName = 'petsBox';

  Future<void> savePets(List<PetDto> pets) async {
    final box = await Hive.openBox<PetDto>(boxName);
    await box.clear();
    await box.addAll(pets);
  }

  Future<List<PetDto>> getPets() async {
    final box = await Hive.openBox<PetDto>(boxName);
    return box.values.toList();
  }
} 