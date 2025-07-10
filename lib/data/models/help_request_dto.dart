import '../../core/enums/emergency_level.dart';
import '../../core/enums/help_request_status.dart';

class HelpRequestDto {
  final int id;
  final String title;
  final String description;
  final EmergencyLevel emergencyLevel;
  final DateTime createdAt;
  final int userId;
  final String userName;
  final String location;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final String? imageUrl;
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