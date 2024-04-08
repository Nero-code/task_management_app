import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_management_app/core/constants/constants.dart';
import 'package:task_management_app/core/failures/exceptions.dart';
import 'package:task_management_app/features/Auth/data/models/user_model.dart';

abstract class RemoteAuthSource {
  Future<UserModel> loginWithCredentials({
    required String email,
    required String password,
  });
  Future<UserModel> signupWithCredentials({
    required String email,
    required String password,
  });
  Future<void> logout();
}

class RemoteAuthSourceImpl implements RemoteAuthSource {
  final http.Client client;

  RemoteAuthSourceImpl(this.client);

  @override
  Future<UserModel> loginWithCredentials(
      {required String email, required String password}) async {
    final result = await httpPost(
      HTTP_API + HTTP_LOGIN_SUFFIX,
      {
        "email": email,
        "password": password,
      },
    );

    print("Login");
    print(result.body);
    if (result.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(result.body);

      return UserModel(
        id: body['id'],
        email: email,
        password: password,
        token: body['token'],
      );
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signupWithCredentials(
      {required String email, required String password}) async {
    final result = await httpPost(
      HTTP_API + HTTP_REGISTER_SUFFIX,
      {
        "email": email,
        "password": password,
      },
    );
    print("Signup");
    print(result.body);
    if (result.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(result.body);
      return UserModel(
          id: data['id'],
          email: email,
          password: password,
          token: data['token']);
    } else {
      throw ServerException();
    }
  }

  //
  //    HELPER HTTP METHODS
  //

  Future<http.Response> httpGet(String uri) async {
    return await client.get(Uri.parse(uri));
  }

  Future<http.Response> httpPost(String uri, Map<String, String> body) async {
    return await client.post(Uri.parse(uri), body: body);
  }

  Future<http.Response> httpPut(String uri) async {
    return await client.get(Uri.parse(uri));
  }

  Future<http.Response> httpDelete(String uri) async {
    return await client.delete(Uri.parse(uri));
  }
}
