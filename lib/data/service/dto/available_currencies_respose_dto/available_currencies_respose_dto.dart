import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_app/domain/models/currency_symbol/currency_symbol.dart';

part 'available_currencies_respose_dto.freezed.dart';
part 'available_currencies_respose_dto.g.dart';

@freezed
class AvailableCurrenciesResposeDto with _$AvailableCurrenciesResposeDto {
  const factory AvailableCurrenciesResposeDto({
    required bool success,
    required Map<String, String> symbols,
  }) = _AvailableCurrenciesResposeDto;

  const AvailableCurrenciesResposeDto._();

  List<CurrencySymbol> getSymbols() => symbols.entries
      .map(
        (e) => CurrencySymbol(
          code: e.key,
          name: e.value,
        ),
      )
      .toList();

  factory AvailableCurrenciesResposeDto.fromJson(Map<String, dynamic> json) =>
      _$AvailableCurrenciesResposeDtoFromJson(json);
}
