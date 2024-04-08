import 'package:dartz/dartz.dart';
import 'package:task_management_app/core/failures/failures.dart';
import 'package:task_management_app/features/Auth/data/models/user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, Unit>> login({
    required String email,
    required String pass,
  });

  Future<Either<Failure, Unit>> signup({
    required String email,
    required String pass,
  });

  Future<Either<Failure, Unit>> saveCredentials({required UserModel user});

  Future<Either<Failure, bool>> isLoggedIn();
}
