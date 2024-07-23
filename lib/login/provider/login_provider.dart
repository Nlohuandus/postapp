import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _showPassword = false;
  String? _error;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isAuthenticated => _isAuthenticated;
  bool get showPassword => _showPassword;
  String? get error => _error;
  GlobalKey<FormState> get formkey => _formKey;

  setIsAuthenticated(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isAuthenticated", value);
    _isAuthenticated = value;
    notifyListeners();
  }

  toggleShowPassword() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  setError(String? error) {
    _error = error;
    notifyListeners();
  }

  String? doAuthentication({required String user, required String password}) {
    setError(null);
    if (user != "challenge@fudo" || password != "password") {
      setError("Usuario o contraseña incorrectos");
    }
    if (password.isEmpty) {
      setError("No se ha ingresado una contraseña");
    }
    if (user.isEmpty) {
      setError("No se ha ingresado un usuario");
    }
    if (_formKey.currentState?.validate() ?? false) {
      setIsAuthenticated(true);
    }
    notifyListeners();
    return _error;
  }
}
