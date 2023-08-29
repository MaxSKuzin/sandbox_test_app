abstract interface class LocalSource {
  Future<dynamic> get(String path);

  Future<void> put(
    String path,
    dynamic data,
  );
}
