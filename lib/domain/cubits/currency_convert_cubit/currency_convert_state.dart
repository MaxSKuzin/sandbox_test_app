part of 'currency_convert_cubit.dart';

@freezed
class CurrencyConvertState with _$CurrencyConvertState {
  const factory CurrencyConvertState.initial() = _Initial;

  const factory CurrencyConvertState.loading() = _Loading;

  const factory CurrencyConvertState.ready(CurrencyConvertResponse response) = _Ready;

  const factory CurrencyConvertState.error() = _Error;
}
