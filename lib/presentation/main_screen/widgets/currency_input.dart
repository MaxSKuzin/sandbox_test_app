import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../domain/cubits/available_currencies_cubit/available_currencies_cubit.dart';
import '../../../domain/models/currency_symbol/currency_symbol.dart';
import 'available_currencies_dialog.dart';

class CurrencyInput extends StatelessWidget {
  final bool enabled;
  final ValueNotifier<CurrencySymbol?> notifier;
  final TextEditingController controller;
  final String label;

  const CurrencyInput({
    super.key,
    required this.label,
    required this.controller,
    required this.notifier,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  enabled: enabled,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).textTheme.bodyMedium!.color!,
                      ),
                    ),
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Gap(16),
              ValueListenableBuilder<CurrencySymbol?>(
                valueListenable: notifier,
                builder: (context, value, child) => TextButton(
                  onPressed: () => _pickCurrency(context),
                  child: Text(
                    value?.code ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _pickCurrency(context),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickCurrency(BuildContext context) async {
    final bloc = context.read<AvailableCurrenciesCubit>()..loadCurrencies();
    final selectedCurrency = await showDialog<CurrencySymbol?>(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: AvailableCurrenciesDialog(
          initialCurrency: notifier.value,
        ),
      ),
    );
    if (selectedCurrency != null) {
      notifier.value = selectedCurrency;
    }
  }
}
