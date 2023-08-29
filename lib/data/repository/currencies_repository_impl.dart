import 'package:injectable/injectable.dart';
import 'package:test_app/data/service/currencies_service.dart';
import 'package:test_app/domain/models/currency_symbol/currency_symbol.dart';

import '../../domain/repositotry/currencies_repository.dart';

@Singleton(as: CurrenciesRepository)
class CurrenciesRepositoryImpl implements CurrenciesRepository {
  final CurrenciesService _currenciesService;

  CurrenciesRepositoryImpl(this._currenciesService);

  Future<List<CurrencySymbol>> getCurrencies() => _currenciesService.getAvailableCurrencies();
}
