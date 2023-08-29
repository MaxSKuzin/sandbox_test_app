import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_convert_response.freezed.dart';

@freezed
class CurrencyConvertResponse with _$CurrencyConvertResponse {
  const factory CurrencyConvertResponse({
    required double result,
  }) = _CurrencyConvertResponse;
}
