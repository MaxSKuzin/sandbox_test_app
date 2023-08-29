import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:test_app/logger.dart';

import '../../models/currency_symbol/currency_symbol.dart';
import '../../repositotry/currencies_repository.dart';

part 'available_currencies_state.dart';
part 'available_currencies_cubit.freezed.dart';

@injectable
class AvailableCurrenciesCubit extends Cubit<AvailableCurrenciesState> {
  final CurrenciesRepository _currenciesRepository;

  AvailableCurrenciesCubit(
    this._currenciesRepository,
  ) : super(const AvailableCurrenciesState.initial());

  Future<void> loadCurrencies() async {
    try {
      if (state is! _Ready) {
        emit(const AvailableCurrenciesState.loading());
      }
      final currencies = await _currenciesRepository.getCurrencies();
      emit(AvailableCurrenciesState.ready(currencies));
    } catch (err, st) {
      emit(const AvailableCurrenciesState.error());
      logger.e(
        err,
        error: err,
        stackTrace: st,
      );
    }
  }
}
