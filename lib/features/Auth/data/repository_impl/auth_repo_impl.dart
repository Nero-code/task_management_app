import 'package:dartz/dartz.dart';
import 'package:task_management_app/core/connections/network_info.dart';
import 'package:task_management_app/core/failures/exceptions.dart';
import 'package:task_management_app/core/failures/failures.dart';
import 'package:task_management_app/features/Auth/data/models/user_model.dart';
import 'package:task_management_app/features/Auth/data/sources/local_auth_source.dart';
import 'package:task_management_app/features/Auth/data/sources/remote_auth_source.dart';
import 'package:task_management_app/features/Auth/domain/repository/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final LocalAuthSource localAuthSource;
  final RemoteAuthSource remoteAuthSource;
  final NetworkInfo networkInfo;

  AuthRepoImpl(this.localAuthSource, this.remoteAuthSource, this.networkInfo);
  @override
  Future<Either<Failure, Unit>> login(
      {required String email, required String pass}) async {
    print(await networkInfo.isConnected());

    if (await networkInfo.isConnected()) {
      try {
        final user = await remoteAuthSource.loginWithCredentials(
            email: email, password: pass);
        await localAuthSource.saveUserCredentials(user);
        return Right(unit);
      } on Exception catch (ex) {
        print(ex);
        return Left(ServerFailure("errMsg"));
      }
    } else {
      return Left(OfflineFailure("errMsg"));
    }
  }

  @override
  Future<Either<Failure, Unit>> signup(
      {required String email, required String pass}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> saveCredentials(
      {required UserModel user}) async {
    try {
      await localAuthSource.saveUserCredentials(user);
      return Right(unit);
    } catch (e) {
      return Left(Failure(""));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      await localAuthSource.getSavedCredentials();
      return Right(true);
    } on EmptyCacheException {
      return Left(EmptyCacheFailure(""));
    }
  }
}
