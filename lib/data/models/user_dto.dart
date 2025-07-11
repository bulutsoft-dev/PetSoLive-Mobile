class UserDto {
  final int id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? address;
  final DateTime? dateOfBirth;
  final bool? isActive;
  final DateTime? createdDate;
  final DateTime? lastLoginDate;
  final String? profileImageUrl;
  final List<String>? roles;
  final String? city;
  final String? district;

  UserDto({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    this.isActive,
    this.createdDate,
    this.lastLoginDate,
    this.profileImageUrl,
    this.roles,
    this.city,
    this.district,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth']) : null,
      isActive: json['isActive'],
      createdDate: json['createdDate'] != null ? DateTime.tryParse(json['createdDate']) : null,
      lastLoginDate: json['lastLoginDate'] != null ? DateTime.tryParse(json['lastLoginDate']) : null,
      profileImageUrl: json['profileImageUrl'] ?? '',
      roles: (json['roles'] as List?)?.map((e) => e.toString()).toList(),
      city: json['city'] ?? '',
      district: json['district'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'isActive': isActive,
    'createdDate': createdDate?.toIso8601String(),
    'lastLoginDate': lastLoginDate?.toIso8601String(),
    'profileImageUrl': profileImageUrl,
    'roles': roles,
    'city': city,
    'district': district,
  };
} 