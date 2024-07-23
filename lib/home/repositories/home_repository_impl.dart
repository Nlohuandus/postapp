import 'package:postapp/core/dio_client.dart';
import 'package:postapp/home/models/post_model.dart';
import 'package:postapp/home/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final _dio = DioClient().dio;

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await _dio.get('posts');

    return (response.data as List)
        // ignore: unnecessary_lambdas
        .map((element) => PostModel.fromJson(element))
        .toList();
  }
}
