// import 'package:equatable/equatable.dart';
// With Equatable package
// class UserEntity extends Equatable {
//   final String id;
//   final String email;
//   final String authType;
//   final String name;

//   const UserEntity({required this.id, required this.email, required this.authType, required this.name});

//   UserEntity copyWith({String? id, String? email, String? authType, String? name}) {
//     return UserEntity(id: id ?? this.id, email: email ?? this.email, authType: authType ?? this.authType, name: name ?? this.name);
//   }

//   @override
//   List<Object?> get props => [id, email, authType, name];
// }

// With Freezed package
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_entity.freezed.dart';

@freezed
sealed class UserEntity with _$UserEntity {
  const factory UserEntity({required String id, required String email, required String authType, required String name}) = _UserEntity;
}
