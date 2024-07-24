import 'package:postapp/home/models/post_model.dart';

abstract class PostsRepository {
  Future<List<PostModel>> getPosts();
  Future<List<PostModel>?> getPostByUser({required String name});
  Future<PostModel> newPost({required PostModel post});
}
