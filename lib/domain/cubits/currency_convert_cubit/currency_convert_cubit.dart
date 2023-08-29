import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:test_app/domain/models/currency_convert_response/currency_convert_response.dart';
import 'package:test_app/logger.dart';

import '../../repositotry/currencies_repository.dart';

part 'currency_convert_state.dart';
part 'currency_convert_cubit.freezed.dart';

@injectable
class CurrencyConvertCubit extends Cubit<CurrencyConvertState> {
  final CurrenciesRepository _currenciesRepository;

  CurrencyConvertCubit(
    this._currenciesRepository,
  ) : super(const CurrencyConvertState.initial());

  Future<void> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      emit(const CurrencyConvertState.loading());
      final response = await _currenciesRepository.convertCurrency(
        from: from,
        to: to,
        amount: amount,
      );
      emit(CurrencyConvertState.ready(response));
    } catch (err, st) {
      logger.e(err, error: err, stackTrace: st);
      emit(const CurrencyConvertState.error());
    }
  }
}
