abstract class RemoteSource {
  Future<dynamic> get(String path, [Map<String, dynamic>? queryParameters]);
}
