import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/currency_input.dart';
import '../../domain/cubits/available_currencies_cubit/available_currencies_cubit.dart';
import '../../domain/models/currency_symbol/currency_symbol.dart';
import '../../injection.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _currencyTo = ValueNotifier<CurrencySymbol?>(null);
  final _currencyFrom = ValueNotifier<CurrencySymbol?>(null);

  @override
  void dispose() {
    _currencyTo.dispose();
    _currencyFrom.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<AvailableCurrenciesCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Currency converter',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Expanded(
                child: CurrencyInput(notifier: _currencyFrom),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.swap_vert_rounded,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                child: CurrencyInput(notifier: _currencyTo),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
