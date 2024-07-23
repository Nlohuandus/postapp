import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postapp/home/provider/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider homeProvider;
  int backCount = 0;

  @override
  initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.getPosts();
  }

  clearSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    await context.push("/");
  }

  onPopInvoked(didPop) {
    backCount += 1;
    Future.delayed(
      const Duration(seconds: 3),
      () => setState(() {
        backCount = 0;
      }),
    );
    if (backCount >= 2) {
      exit(0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Presione otra vez para salir"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: clearSharedPrefs,
              icon: const Icon(Icons.logout),
            ),
          ],
          title: const Text("Posts"),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(32),
          shrinkWrap: true,
          itemCount: context.watch<HomeProvider>().postList.length,
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple.shade500),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              children: [
                Text(
                  homeProvider.postList[index].title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  homeProvider.postList[index].body,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "userID : ${homeProvider.postList[index].id}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      "postID : ${homeProvider.postList[index].id}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
        ),
      ),
    );
  }
}
