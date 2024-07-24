import 'package:dio/dio.dart';
import 'package:postapp/core/dio_client.dart';
import 'package:postapp/home/models/post_model.dart';
import 'package:postapp/home/models/user_model.dart';
import 'package:postapp/repositories/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  final _dio = DioClient().dio;

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _dio.get('posts');

      return (response.data as List)
          .map((element) => PostModel.fromJson(element))
          .toList();
    } on DioException {
      throw Exception("No hay conexion a internet");
    }
  }

  @override
  Future<List<PostModel>?> getPostByUser({required String name}) async {
    Map<String, dynamic> queryParameters = {"name": name};
    final response = await _dio.get('users', queryParameters: queryParameters);

    UserModel? user = (response.data as List)
        .map((element) => UserModel.fromJson(element))
        .toList()
        .firstOrNull;

    if (user != null) {
      return await getPostByUserId(userId: user.id!);
    } else {
      throw Exception("No se encontro usuario");
    }
  }

  Future<List<PostModel>> getPostByUserId({required int userId}) async {
    final response = await _dio.get(
      'users/$userId/posts',
    );

    return (response.data as List)
        .map((element) => PostModel.fromJson(element))
        .toList();
  }

  @override
  Future<PostModel> newPost({required PostModel post}) async {
    try {
      final response = await _dio.post(
        'posts',
        data: post.toJson(),
      );

      return PostModel.fromJson(response.data);
    } catch (e) {
      throw Exception("No se pudo crear el Post");
    }
  }
}
