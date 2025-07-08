class RegisterDto {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final String city;
  final String district;
  final String? profileImageUrl;

  RegisterDto({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.city,
    required this.district,
    this.profileImageUrl,
  });

  factory RegisterDto.fromJson(Map<String, dynamic> json) {
    return RegisterDto(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      city: json['city'],
      district: json['district'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'address': address,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'profileImageUrl': profileImageUrl ?? 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.freepik.com%2Ffree-icon%2Fuser_318-804790.jpg&f=1&nofb=1&ipt=5936ab431b7527eb5f5e20fc8c26d918ebeea72414e3fa5b59a57ea07459717f',
    'city': city.isNotEmpty ? city : '',
    'district': district.isNotEmpty ? district : '',
  };
} 