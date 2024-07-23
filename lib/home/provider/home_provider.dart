import 'package:flutter/material.dart';
import 'package:postapp/home/models/post_model.dart';
import 'package:postapp/home/repositories/home_repository_impl.dart';

class HomeProvider with ChangeNotifier {
  final HomeRepositoryImpl _homeRepository = HomeRepositoryImpl();
  List<PostModel> _postList = [];
  List<PostModel>? _filteredPostList;

  List<PostModel> get postList => _postList;
  List<PostModel>? get filteredPostList => _filteredPostList;

  getPosts() async {
    _postList = await _homeRepository.getPosts();
    notifyListeners();
  }

  getPostByUser({required String name}) async {
    _filteredPostList = await _homeRepository.getPostByUser(name: name);
    notifyListeners();
  }
}
