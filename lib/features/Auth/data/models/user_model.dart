import 'package:task_management_app/features/Auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.id,
      required super.email,
      required super.password,
      required super.token});

  factory UserModel.fromJson(Map<String, dynamic> data) => UserModel(
        id: data['id'],
        email: data['email'],
        password: data['password'],
        token: data['token'],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        "token": token,
      };
}
