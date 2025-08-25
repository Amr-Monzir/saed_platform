import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory User({
    required int id,
    required String email,
    required UserType userType,
    required bool isActive,
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Token with _$Token {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Token({
    required String accessToken,
    required String tokenType,
    String? refreshToken, // Add refresh token
    int? expiresIn, // Add expiration time in seconds
  }) = _Token;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
}

@freezed
class TokenData with _$TokenData {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TokenData({
    String? email,
  }) = _TokenData;

  factory TokenData.fromJson(Map<String, dynamic> json) => _$TokenDataFromJson(json);
}


