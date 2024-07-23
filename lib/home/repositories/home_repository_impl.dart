import 'package:postapp/core/dio_client.dart';
import 'package:postapp/home/models/post_model.dart';
import 'package:postapp/home/models/user_model.dart';
import 'package:postapp/home/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final _dio = DioClient().dio;

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await _dio.get('posts');

    return (response.data as List)
        .map((element) => PostModel.fromJson(element))
        .toList();
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
      return null;
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
}
