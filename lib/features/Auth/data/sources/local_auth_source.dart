import 'package:sqflite/sqflite.dart';
import 'package:task_management_app/core/constants/constants.dart';
import 'package:task_management_app/core/failures/exceptions.dart';
import 'package:task_management_app/features/Auth/data/models/user_model.dart';

abstract class LocalAuthSource {
  Future<UserModel> getSavedCredentials();
  Future<int> saveUserCredentials(UserModel model);
}

class LocalAuthSourceImpl implements LocalAuthSource {
  final Database database;

  const LocalAuthSourceImpl(this.database);

  @override
  Future<UserModel> getSavedCredentials() async {
    final result = await database.query(USERTABLE);
    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first);
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<int> saveUserCredentials(UserModel model) async {
    await database.execute("DELETE FROM $USERTABLE");
    return await database.insert(USERTABLE, model.toJson());
  }
}
