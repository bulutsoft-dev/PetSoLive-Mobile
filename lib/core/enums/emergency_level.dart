import 'package:hive/hive.dart';
part 'emergency_level.g.dart';

@HiveType(typeId: 10)
enum EmergencyLevel {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
} 