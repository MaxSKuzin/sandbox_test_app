part of 'available_currencies_cubit.dart';

@freezed
class AvailableCurrenciesState with _$AvailableCurrenciesState {
  const factory AvailableCurrenciesState.initial() = _Initial;

  const factory AvailableCurrenciesState.loading() = _Loading;

  const factory AvailableCurrenciesState.ready(
    final List<CurrencySymbol> currencies,
  ) = _Ready;

  const factory AvailableCurrenciesState.error() = _Error;
}
