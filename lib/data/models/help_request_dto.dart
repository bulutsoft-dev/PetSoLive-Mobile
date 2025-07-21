import 'package:hive/hive.dart';
import '../../core/enums/emergency_level.dart';
import '../../core/enums/help_request_status.dart';
part 'help_request_dto.g.dart';

@HiveType(typeId: 2)
class HelpRequestDto {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final EmergencyLevel emergencyLevel;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final int userId;
  @HiveField(6)
  final String userName;
  @HiveField(7)
  final String location;
  @HiveField(8)
  final String? contactName;
  @HiveField(9)
  final String? contactPhone;
  @HiveField(10)
  final String? contactEmail;
  @HiveField(11)
  final String? imageUrl;
  @HiveField(12)
  final HelpRequestStatus status;

  HelpRequestDto({
    required this.id,
    required this.title,
    required this.description,
    required this.emergencyLevel,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.location,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.imageUrl,
    required this.status,
  });

  factory HelpRequestDto.fromJson(Map<String, dynamic> json) {
    EmergencyLevel parseEmergencyLevel(String? value) {
      switch (value) {
        case 'Low':
          return EmergencyLevel.low;
        case 'Medium':
          return EmergencyLevel.medium;
        case 'High':
          return EmergencyLevel.high;
        default:
          return EmergencyLevel.low;
      }
    }
    HelpRequestStatus parseStatus(String? value) {
      switch (value) {
        case 'Active':
          return HelpRequestStatus.Active;
        case 'Passive':
          return HelpRequestStatus.Passive;
        default:
          return HelpRequestStatus.Active;
      }
    }
    return HelpRequestDto(
      id: json['id'],
      userId: json['userId'],
      description: json['description'],
      emergencyLevel: parseEmergencyLevel(json['emergencyLevel']),
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      userName: json['userName'],
      location: json['location'],
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      contactEmail: json['contactEmail'],
      imageUrl: json['imageUrl'],
      status: parseStatus(json['status']),
    );
  }

  String _pascalCase(String s) => s[0].toUpperCase() + s.substring(1).toLowerCase();

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'description': description,
    'emergencyLevel': _pascalCase(emergencyLevel.name),
    'createdAt': createdAt.toIso8601String(),
    'title': title,
    'userName': userName,
    'location': location,
    'contactName': contactName,
    'contactPhone': contactPhone,
    'contactEmail': contactEmail,
    'imageUrl': imageUrl,
    'status': _pascalCase(status.name),
  };
} 