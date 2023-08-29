import 'package:injectable/injectable.dart';
import 'package:test_app/data/util/network_cache_util.dart';
import 'package:test_app/domain/models/currency_symbol/currency_symbol.dart';

import '../../env.dart';
import 'dto/available_currencies_respose_dto/available_currencies_respose_dto.dart';

@singleton
class CurrenciesService {
  static const _baseUrl = 'http://api.exchangeratesapi.io/v1/';

  String _getSymbolsRoute() => '/symbols';

  String _getConvertRoute() => '/convert';

  final NetworkCacheUtil _cacheUtil;

  CurrenciesService(this._cacheUtil);

  Future<List<CurrencySymbol>> getAvailableCurrencies() async {
    final response = await _cacheUtil.get(
      '$_baseUrl${_getSymbolsRoute()}',
      {
        'access_key': Env.apiKey,
      },
    ).then(
      (value) => AvailableCurrenciesResposeDto.fromJson(value),
    );
    if (response.success) {
      return response.getSymbols();
    } else {
      throw 'Request failed';
    }
  }
}
