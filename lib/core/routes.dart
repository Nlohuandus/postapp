import 'package:flutter/material.dart';
import 'package:postapp/home/home_screen.dart';
import 'package:postapp/login/screen/login_screen.dart';

final Map<String, WidgetBuilder> routes = {
  "login": (context) => const LoginScreen(),
  "home": (context) => const HomeScreen(),
};
