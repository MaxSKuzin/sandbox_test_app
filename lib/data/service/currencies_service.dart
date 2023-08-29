import 'package:injectable/injectable.dart';
import 'package:test_app/data/service/dto/currency_convert_request/currency_convert_request.dart';
import 'package:test_app/data/util/network_cache_util.dart';
import 'package:test_app/domain/models/currency_symbol/currency_symbol.dart';

import '../../domain/models/currency_convert_response/currency_convert_response.dart';
import '../../env.dart';
import 'dto/available_currencies_respose_dto/available_currencies_respose_dto.dart';
import 'dto/currency_convert_response_dto/currency_convert_response_dto.dart';

@singleton
class CurrenciesService {
  static const _baseUrl = 'http://api.exchangeratesapi.io/v1';

  String _getSymbolsRoute() => '/symbols';

  // exchangeratesapi does not allow converting
  String _getConvertRoute() => 'https://api.api-ninjas.com/v1/convertcurrency';

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

    return response.getSymbols();
  }

  Future<CurrencyConvertResponse> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    final request = CurrencyConvertRequest(
      have: from,
      want: to,
      amount: amount,
    );
    final response = await _cacheUtil
        .get(
          _getConvertRoute(),
          request.toJson(),
        )
        .then(
          (value) => CurrencyConvertResponseDto.fromJson(value),
        );
    return response.toDomain(to);
  }
}
