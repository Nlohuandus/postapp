import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postapp/home/provider/home_provider.dart';
import 'package:postapp/home/widgets/post_list.dart';
import 'package:postapp/login/widget/default_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  late HomeProvider homeProvider;
  int backCount = 0;

  @override
  initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    searchController.addListener(
      () {
        if (searchController.text.isEmpty) {
          homeProvider.setFilteredPostList(null);
        }
      },
    );
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
      DefaultSnackbar.show(
        context,
        "Presione otra vez para salir",
        Colors.black54,
      );
    }
  }

  searchByUser() async {
    FocusManager.instance.primaryFocus!.unfocus();
    try {
      await homeProvider.getPostByUser(
        name: searchController.text,
      );
    } catch (e) {
      if (!mounted) return;
      DefaultSnackbar.show(
        context,
        e.toString(),
        Colors.black54,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              actions: [
                IconButton(
                  onPressed: clearSharedPrefs,
                  icon: const Icon(Icons.logout),
                ),
              ],
              title: TextField(
                controller: searchController,
                onEditingComplete: searchByUser,
                decoration: InputDecoration(
                  hintText: "Buscar por nombre de usuario",
                  border: const OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: searchByUser,
                        child: const Icon(Icons.search),
                      ),
                      GestureDetector(
                        onTap: () {
                          searchController.clear();
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        child: const Icon(Icons.close),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PostList(postList: context.watch<HomeProvider>().postListToShow),
          ],
        ),
      ),
    );
  }
}
