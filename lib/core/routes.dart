import 'package:go_router/go_router.dart';
import 'package:postapp/home/home_screen.dart';
import 'package:postapp/login/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      name: "login",
      builder: (context, state) => const LoginScreen(),
      redirect: (context, state) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        bool? isAuthenticated = prefs.getBool("isAuthenticated");
        if (isAuthenticated ?? false) {
          return '/home';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      path: '/home',
      name: "home",
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
