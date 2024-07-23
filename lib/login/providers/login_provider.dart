import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  setIsAuthenticated(bool value) => _isAuthenticated = value;
}
