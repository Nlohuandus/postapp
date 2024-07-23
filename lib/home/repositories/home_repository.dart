import 'package:postapp/home/models/post_model.dart';

abstract class HomeRepository {
  Future<List<PostModel>> getPosts();
  Future<List<PostModel>?> getPostByUser({required String name});
}
