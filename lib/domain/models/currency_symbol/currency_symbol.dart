import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_symbol.freezed.dart';

@freezed
class CurrencySymbol with _$CurrencySymbol {
  const factory CurrencySymbol({
    required String code,
    required String name,
  }) = _CurrencySymbol;
}
