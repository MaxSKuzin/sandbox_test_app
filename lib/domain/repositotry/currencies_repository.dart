import 'package:test_app/domain/models/currency_convert_response/currency_convert_response.dart';
import 'package:test_app/domain/models/currency_symbol/currency_symbol.dart';

abstract interface class CurrenciesRepository {
  Future<List<CurrencySymbol>> getCurrencies();

  Future<CurrencyConvertResponse> convertCurrency({
    required String from,
    required String to,
    required double amount,
  });
}
