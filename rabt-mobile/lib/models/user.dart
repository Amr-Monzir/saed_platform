import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';

part 'user.g.dart';

@JsonSerializable()
class UserResponse {
  UserResponse({
    required this.id,
    required this.email,
    required this.userType,
    required this.isActive,
    required this.createdAt,
  });

  final int id;
  final String email;
  @JsonKey(name: 'user_type')
  final UserType userType;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class Token {
  Token({required this.accessToken, required this.tokenType});
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'token_type')
  final String tokenType;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

@JsonSerializable()
class TokenData {
  TokenData({this.email});
  final String? email;

  factory TokenData.fromJson(Map<String, dynamic> json) => _$TokenDataFromJson(json);
  Map<String, dynamic> toJson() => _$TokenDataToJson(this);
}


