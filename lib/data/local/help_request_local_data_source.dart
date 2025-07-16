import 'package:hive/hive.dart';
import '../models/help_request_dto.dart';

class HelpRequestLocalDataSource {
  static const String boxName = 'helpRequestsBox';

  Future<void> saveRequests(List<HelpRequestDto> requests) async {
    final box = await Hive.openBox<HelpRequestDto>(boxName);
    await box.clear();
    await box.addAll(requests);
  }

  Future<List<HelpRequestDto>> getRequests() async {
    final box = await Hive.openBox<HelpRequestDto>(boxName);
    return box.values.toList();
  }
} 