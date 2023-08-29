import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:synchronized/synchronized.dart';
import 'package:test_app/data/source/local_source.dart';

import '../source/remote_source.dart';

@singleton
class NetworkCacheUtil {
  final RemoteSource _remoteSource;
  final LocalSource _localSource;
  final _connectionStatusStream = BehaviorSubject<bool>.seeded(true);
  final _lock = Lock();
  Timer? _timer;

  NetworkCacheUtil(
    this._localSource,
    this._remoteSource,
  );

  Future<T?> get<T>(String path, [Map<String, dynamic>? queryParameters]) async {
    if (_connectionStatusStream.value) {
      return _fetchData(path, queryParameters);
    } else {
      Future(
        () async {
          if (!_lock.locked) {
            await _lock.synchronized(
              () => _connectionStatusStream.firstWhere(
                (hasConnection) => hasConnection,
              ),
            );
          } else {
            await _lock.synchronized(() {});
          }
          await _fetchNetworkData(path, queryParameters);
        },
      );
      return _getLocalData(path, queryParameters);
    }
  }

  String _getCachePath(String path, Map<String, dynamic>? queryParameters) {
    final parameters = queryParameters?.entries.map((entry) => '${entry.key}:${entry.value}');
    return '$path${parameters != null ? '?/parameters' : ''}';
  }

  Future<T?> _fetchData<T>(String path, Map<String, dynamic>? queryParameters) async {
    try {
      return await _fetchNetworkData(path, queryParameters);
    } catch (err) {
      _startPolling();
      return _getLocalData(path, queryParameters);
    }
  }

  Future<T?> _fetchNetworkData<T>(String path, Map<String, dynamic>? queryParameters) async {
    final data = await _remoteSource.get(path, queryParameters);
    final cachePath = _getCachePath(path, queryParameters);
    _localSource.put('$path$cachePath}', data);
    return data as T;
  }

  Future<T?> _getLocalData<T>(String path, Map<String, dynamic>? queryParameters) async {
    final cachePath = _getCachePath(path, queryParameters);
    final data = await _localSource.get<T>('$path$cachePath}');
    return data;
  }

  void _startPolling() {
    _connectionStatusStream.add(false);
    final timer = _timer;
    if (timer != null && !timer.isActive) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) async {
          try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty) {
              _connectionStatusStream.add(true);
              timer.cancel();
              _timer = null;
            }
          } catch (_) {}
        },
      );
    }
  }
}
