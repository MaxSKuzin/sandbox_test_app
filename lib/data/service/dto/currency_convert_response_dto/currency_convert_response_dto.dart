import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/models/currency_convert_response/currency_convert_response.dart';

part 'currency_convert_response_dto.freezed.dart';
part 'currency_convert_response_dto.g.dart';

@freezed
class CurrencyConvertResponseDto with _$CurrencyConvertResponseDto {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CurrencyConvertResponseDto({
    required double newAmount,
    required double oldAmount,
    required String oldCurrency,
    required String newCurrency,
  }) = _CurrencyConvertResponseDto;

  const CurrencyConvertResponseDto._();

  CurrencyConvertResponse toDomain(String code) => CurrencyConvertResponse(
        result: newAmount,
      );

  factory CurrencyConvertResponseDto.fromJson(Map<String, dynamic> json) => _$CurrencyConvertResponseDtoFromJson(json);
}
