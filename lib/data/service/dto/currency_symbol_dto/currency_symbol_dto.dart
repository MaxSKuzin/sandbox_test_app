import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/models/currency_symbol/currency_symbol.dart';

part 'currency_symbol_dto.freezed.dart';
part 'currency_symbol_dto.g.dart';

@freezed
class CurrencySymbolDto with _$CurrencySymbolDto {
  const factory CurrencySymbolDto({
    required String symbol,
    required String name,
  }) = _CurrencySymbolDto;

  const CurrencySymbolDto._();

  CurrencySymbol toDomain() => CurrencySymbol(
        code: symbol,
        name: name,
      );

  factory CurrencySymbolDto.fromJson(Map<String, dynamic> json) => _$CurrencySymbolDtoFromJson(json);
}
