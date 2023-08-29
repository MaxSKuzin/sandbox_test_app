import 'package:injectable/injectable.dart';
import 'package:test_app/data/service/currencies_service.dart';
import 'package:test_app/domain/models/currency_convert_response/currency_convert_response.dart';
import 'package:test_app/domain/models/currency_symbol/currency_symbol.dart';

import '../../domain/repositotry/currencies_repository.dart';

@Singleton(as: CurrenciesRepository)
class CurrenciesRepositoryImpl implements CurrenciesRepository {
  final CurrenciesService _currenciesService;

  CurrenciesRepositoryImpl(this._currenciesService);

  @override
  Future<List<CurrencySymbol>> getCurrencies() => _currenciesService.getAvailableCurrencies();

  @override
  Future<CurrencyConvertResponse> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) =>
      _currenciesService.convertCurrency(
        from: from,
        to: to,
        amount: amount,
      );
}
