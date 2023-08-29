import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../domain/cubits/available_currencies_cubit/available_currencies_cubit.dart';
import '../../../domain/models/currency_symbol/currency_symbol.dart';
import 'available_currencies_dialog.dart';

class CurrencyInput extends StatelessWidget {
  final ValueNotifier<CurrencySymbol?> notifier;

  const CurrencyInput({
    super.key,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(),
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

