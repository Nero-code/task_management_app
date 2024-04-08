import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String email, password, token;
  const User(
      {this.id,
      required this.email,
      required this.password,
      required this.token});
  @override
  List<Object?> get props => [];
}
