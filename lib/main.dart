import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:postapp/core/routes.dart';
import 'package:postapp/providers/login_provider.dart';
import 'package:postapp/providers/posts_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider<PostsProvider>(
          create: (_) => PostsProvider(),
        ),
      ],
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: LoaderOverlay(child: MyApp()),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
