import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:postapp/home/widgets/post_list.dart';
import 'package:postapp/login/widget/default_snackbar.dart';
import 'package:postapp/providers/posts_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  late PostsProvider homeProvider;
  int backCount = 0;

  @override
  initState() {
    super.initState();
    homeProvider = Provider.of<PostsProvider>(context, listen: false);
    searchController.addListener(
      () {
        if (searchController.text.isEmpty) {
          homeProvider.setFilteredPostList(null);
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback(getPosts);
  }

  getPosts(_) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    try {
      context.loaderOverlay.show();
      await homeProvider.getPosts();
    } catch (e) {
      homeProvider.restoreLastHomeData();
      DefaultSnackbar.show(
        context,
        text: "Sin conexion a internet",
        color: Colors.red.shade300,
        persistent: true,
      );
    } finally {
      context.loaderOverlay.hide();
    }
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
        text: "Presione otra vez para salir",
        color: Colors.black54,
      );
    }
  }

  searchByUser() async {
    FocusManager.instance.primaryFocus!.unfocus();
    try {
      context.loaderOverlay.show();
      await homeProvider.getPostByUser(
        name: searchController.text,
      );
    } catch (e) {
      if (!mounted) return;
      DefaultSnackbar.show(
        context,
        text: e.toString(),
        color: Colors.black54,
      );
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async => context.pushNamed("new-post"),
          backgroundColor: Colors.deepPurple,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => getPosts(Duration.zero),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
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
              PostList(postList: context.watch<PostsProvider>().postListToShow),
            ],
          ),
        ),
      ),
    );
  }
}
