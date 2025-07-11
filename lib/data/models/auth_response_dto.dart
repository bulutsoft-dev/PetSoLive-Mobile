import 'user_dto.dart';
import 'package:flutter/foundation.dart';

class AuthResponseDto {
  final String token;
  final UserDto user;

  AuthResponseDto({
    required this.token,
    required this.user,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    debugPrint('AuthResponseDto JSON: ' + json.toString());
    return AuthResponseDto(
      token: json['token'],
      user: UserDto.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'user': user.toJson(),
  };
} 