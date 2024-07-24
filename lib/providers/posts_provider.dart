import 'package:flutter/material.dart';
import 'package:postapp/home/models/post_model.dart';
import 'package:postapp/repositories/posts_repository_impl.dart';

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
    _postList = await _homeRepository.getPosts();
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

  Future<void> newPost({required PostModel newPost}) async {
    try {
      await _homeRepository.newPost(post: newPost);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
