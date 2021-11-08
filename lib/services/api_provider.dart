// ignore_for_file: invalid_return_type_for_catch_error

import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/services/api_service.dart';

class ApiProvider {
  Future<User> getCurrentUser() async {
    return await APIService.getLoggedUser().then((user) {
      print("success $user");
      return user;
    }).catchError((error) {
      print("Filed $error");
      return null;
    });
  }
}
