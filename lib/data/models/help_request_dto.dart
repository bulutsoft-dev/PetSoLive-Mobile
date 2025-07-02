class HelpRequestDto {
  final int id;
  final String title;
  final String description;
  final String emergencyLevel;
  final DateTime createdAt;
  final int userId;
  final String userName;
  final String location;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final String? imageUrl;
  final String status;

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
    return HelpRequestDto(
      id: json['id'],
      userId: json['userId'],
      description: json['description'],
      emergencyLevel: json['emergencyLevel'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      userName: json['userName'],
      location: json['location'],
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      contactEmail: json['contactEmail'],
      imageUrl: json['imageUrl'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'description': description,
    'emergencyLevel': emergencyLevel,
    'createdAt': createdAt.toIso8601String(),
    'title': title,
    'userName': userName,
    'location': location,
    'contactName': contactName,
    'contactPhone': contactPhone,
    'contactEmail': contactEmail,
    'imageUrl': imageUrl,
    'status': status,
  };
} 