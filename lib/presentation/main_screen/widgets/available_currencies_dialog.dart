import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;


import '../../../domain/cubits/available_currencies_cubit/available_currencies_cubit.dart';
import '../../../domain/models/currency_symbol/currency_symbol.dart';

class AvailableCurrenciesDialog extends StatefulWidget {
  final CurrencySymbol? initialCurrency;

  const AvailableCurrenciesDialog({
    required this.initialCurrency,
    super.key,
  });

  @override
  State<AvailableCurrenciesDialog> createState() => _AvailableCurrenciesDialogState();
}

class _AvailableCurrenciesDialogState extends State<AvailableCurrenciesDialog> {
  late final _selectedCurrency = ValueNotifier<CurrencySymbol?>(widget.initialCurrency);

  @override
  void dispose() {
    _selectedCurrency.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: BlocBuilder<AvailableCurrenciesCubit, AvailableCurrenciesState>(
        builder: (context, state) => SizedBox(
          height: math.min(MediaQuery.sizeOf(context).height / 2, 400),
          width: MediaQuery.sizeOf(context).width * 3 / 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a currency',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              state.when(
                ready: (currencies) => Expanded(
                  child: ValueListenableBuilder<CurrencySymbol?>(
                    valueListenable: _selectedCurrency,
                    builder: (context, value, child) => ListView.builder(
                      itemCount: currencies.length,
                      itemBuilder: (context, index) {
                        final element = currencies[index];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio(
                              value: element,
                              groupValue: value,
                              onChanged: (value) => _selectedCurrency.value = value,
                            ),
                            TextButton(
                              onPressed: () => _selectedCurrency.value = element,
                              child: Text(
                                element.code,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: () => Text(
                  'An error occured, try again later',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                initial: () => const SizedBox(),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(
            "CANCEL",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        TextButton(
          child: Text(
            "OK",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
          ),
          onPressed: () => Navigator.of(context).pop(_selectedCurrency.value),
        ),
      ],
    );
  }
}
