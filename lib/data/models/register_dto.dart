class RegisterDto {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final String? profileImageUrl;
  final String? city;
  final String? district;

  RegisterDto({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    this.profileImageUrl,
    this.city,
    this.district,
  });
} 