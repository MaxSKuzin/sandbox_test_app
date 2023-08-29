import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/data/source/local_source.dart';

@preResolve
@Singleton(as: LocalSource)
class SpSource implements LocalSource {
  final SharedPreferences _sp;

  SpSource._(this._sp);

  @factoryMethod
  static Future<SpSource> create() async {
    final sp = await SharedPreferences.getInstance();
    return SpSource._(sp);
  }

  @override
  Future<dynamic> get(String path) async {
    final data = _sp.getString(path);
    return data != null ? jsonDecode(data) : null;
  }

  @override
  Future<void> put(String path, data) {
    return _sp.setString(path, jsonEncode(data));
  }
}
