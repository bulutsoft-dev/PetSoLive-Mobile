class AuthDto {
  final String username;
  final String password;

  AuthDto({
    required this.username,
    required this.password,
  });

  factory AuthDto.fromJson(Map<String, dynamic> json) {
    return AuthDto(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
} 