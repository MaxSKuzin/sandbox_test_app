import 'package:test_app/domain/models/currency_symbol/currency_symbol.dart';

abstract interface class CurrenciesRepository {
  Future<List<CurrencySymbol>> getCurrencies();
}
