import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:postapp/home/models/post_model.dart';
import 'package:postapp/repositories/posts_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsProvider with ChangeNotifier {
  final PostsRepositoryImpl _homeRepository = PostsRepositoryImpl();
  List<PostModel> _postList = [];
  List<PostModel>? _filteredPostList;

  List<PostModel> get postList => _postList;
  List<PostModel>? get filteredPostList => _filteredPostList;
  List<PostModel> get postListToShow {
    if (_filteredPostList != null) {
      return _filteredPostList!;
    } else {
      return _postList;
    }
  }

  setFilteredPostList(List<PostModel>? filteredPostList) {
    _filteredPostList = filteredPostList;
    notifyListeners();
  }

  getPosts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _postList = await _homeRepository.getPosts();
      await prefs.setString("lastHomeData", jsonEncode(_postList));
    } on SocketException {
      rethrow;
    }
    notifyListeners();
  }

  restoreLastHomeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String unparsedData = prefs.getString("lastHomeData") ?? '[]';
    var list = jsonDecode(unparsedData);
    _postList =
        (list as List).map((element) => PostModel.fromJson(element)).toList();
    notifyListeners();
  }

  Future<void> getPostByUser({required String name}) async {
    try {
      _filteredPostList = await _homeRepository.getPostByUser(name: name);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> newPost({required String title, required String body}) async {
    try {
      PostModel newPost = PostModel(title: title, body: body, userId: 5);
      await _homeRepository.newPost(post: newPost);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
