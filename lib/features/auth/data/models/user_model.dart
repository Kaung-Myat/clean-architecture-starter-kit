import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String authType;
  final String name;

  const UserModel({required this.id, required this.email, required this.authType, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email'], authType: json['type'], name: json['name'] ?? 'Guest');
  }

  UserEntity toEntity() {
    return UserEntity(id: id, email: email, authType: authType, name: name);
  }
}
