import 'package:equatable/equatable.dart';

/// Pure domain entity — no Freezed, no JSON, no Flutter.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.authType,
    required this.name,
  });

  final String id;
  final String email;
  final String authType;
  final String name;

  UserEntity copyWith({
    String? id,
    String? email,
    String? authType,
    String? name,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      authType: authType ?? this.authType,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, email, authType, name];
}
