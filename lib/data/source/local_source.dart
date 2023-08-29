abstract class LocalSource {
  Future<T?> get<T>(String path);

  Future<void> put(
    String path,
    dynamic data,
  );
}
