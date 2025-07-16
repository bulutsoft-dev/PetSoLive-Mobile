import 'package:hive/hive.dart';
part 'help_request_status.g.dart';

@HiveType(typeId: 11)
enum HelpRequestStatus {
  @HiveField(0)
  Active,
  @HiveField(1)
  Passive,
} 