import 'package:dartz/dartz.dart';
import 'package:task_management_app/core/failures/failures.dart';
import 'package:task_management_app/features/Auth/domain/repository/auth_repo.dart';

class AuthUsecases {
  final AuthRepo authRepo;
  AuthUsecases(this.authRepo);

  Future<Either<Failure, Unit>> login(
      {required String email, required String password}) async {
    return await authRepo.login(email: email, pass: password);
  }

  Future<Either<Failure, Unit>> signup({
    required String email,
    required String password,
  }) async {
    return await authRepo.login(email: email, pass: password);
  }

  Future<Either<Failure, bool>> isLoggedIn() async {
    return await authRepo.isLoggedIn();
  }
}
