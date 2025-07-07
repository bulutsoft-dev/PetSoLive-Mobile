class UserModel {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final bool isActive;
  final DateTime createdDate;
  final DateTime? lastLoginDate;
  final String profileImageUrl;
  final List<String> roles;
  final String city;
  final String district;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.isActive,
    required this.createdDate,
    this.lastLoginDate,
    required this.profileImageUrl,
    required this.roles,
    required this.city,
    required this.district,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      isActive: json['isActive'],
      createdDate: DateTime.parse(json['createdDate']),
      lastLoginDate: json['lastLoginDate'] != null ? DateTime.parse(json['lastLoginDate']) : null,
      profileImageUrl: json['profileImageUrl'],
      roles: List<String>.from(json['roles']),
      city: json['city'],
      district: json['district'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'isActive': isActive,
    'createdDate': createdDate.toIso8601String(),
    'lastLoginDate': lastLoginDate?.toIso8601String(),
    'profileImageUrl': profileImageUrl,
    'roles': roles,
    'city': city,
    'district': district,
  };
} 