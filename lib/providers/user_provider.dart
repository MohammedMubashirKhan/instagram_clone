import 'package:flutter/material.dart';
import 'package:instragran_clone/models/user.dart' as model;
import 'package:instragran_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  model.User? _user = null;
  final AuthMethods _authMethods = AuthMethods();

  model.User get getUser {
    print("I am returning _user");
    return _user!;
  }

  model.User getUserData() {
    return _user!;
  }

  Future<void> refreshUser() async {
    model.User user = await _authMethods.getUserDetails();
    _user = user;
    print("Data is assigned to provider");
    notifyListeners();
  }

  void saveData(user) {
    _user = user;
    notifyListeners();
  }
}
