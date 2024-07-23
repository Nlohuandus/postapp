import 'package:flutter/material.dart';
import 'package:postapp/home/models/post_model.dart';
import 'package:postapp/home/repositories/home_repository_impl.dart';

class HomeProvider with ChangeNotifier {
  final HomeRepositoryImpl _homeRepository = HomeRepositoryImpl();
  List<PostModel> _postList = [];

  List<PostModel> get postList => _postList;

  getPosts() async {
    _postList = await _homeRepository.getPosts();
    notifyListeners();
  }
}
