import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:test_app/data/source/remote_source.dart';

@preResolve
@Singleton(as: RemoteSource)
class DioSource implements RemoteSource {
  final Dio _dio;

  DioSource._(this._dio);

  @factoryMethod
  static Future<DioSource> create() async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(
          seconds: 40,
        ),
      ),
    );

    return DioSource._(dio);
  }

  @override
  Future<dynamic> get(
    String path, [
    Map<String, dynamic>? queryParameters,
  ]) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return response.data;
  }
}
