import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_convert_request.freezed.dart';
part 'currency_convert_request.g.dart';

@freezed
class CurrencyConvertRequest with _$CurrencyConvertRequest {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CurrencyConvertRequest({
    required String have,
    required String want,
    required double amount,
  }) = _CurrencyConvertRequest;

  const CurrencyConvertRequest._();

  factory CurrencyConvertRequest.fromJson(Map<String, dynamic> json) => _$CurrencyConvertRequestFromJson(json);
}
