import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/cubits/currency_convert_cubit/currency_convert_cubit.dart';
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
  final _amountFromController = TextEditingController();
  final _amountToController = TextEditingController();
  final _convertBloc = getIt.get<CurrencyConvertCubit>();
  String? _oldAmout;

  @override
  void initState() {
    _amountFromController.addListener(_amountFromListener);
    _currencyFrom.addListener(_amountFromListener);
    _currencyTo.addListener(_amountFromListener);

    super.initState();
  }

  @override
  void dispose() {
    _convertBloc.close();
    _currencyTo.dispose();
    _currencyFrom.dispose();
    _amountFromController.dispose();
    _amountToController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt.get<AvailableCurrenciesCubit>(),
          ),
          BlocProvider.value(
            value: _convertBloc,
          ),
        ],
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
          body: BlocListener<CurrencyConvertCubit, CurrencyConvertState>(
            listener: (context, state) => state.when(
              initial: () => null,
              loading: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
                return null;
              },
              ready: (response) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _amountToController.text = response.result.toString();
                return null;
              },
              error: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        'An error occured, try again later',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                );
                return null;
              },
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Expanded(
                    child: CurrencyInput(
                      label: 'You send',
                      notifier: _currencyFrom,
                      controller: _amountFromController,
                    ),
                  ),
                  IconButton(
                    onPressed: _exchange,
                    icon: Icon(
                      Icons.swap_vert_rounded,
                      size: 32,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    child: CurrencyInput(
                      label: 'They get',
                      enabled: false,
                      notifier: _currencyTo,
                      controller: _amountToController,
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _amountFromListener() {
    final amount = double.tryParse(_amountFromController.text);
    if (_currencyFrom.value == null || _currencyTo.value == null || amount == null) {
      return;
    }
    if (_oldAmout == _amountFromController.text) {
      return;
    }
    _oldAmout = _amountFromController.text;
    EasyDebounce.debounce(
      'convert-debouncer',
      const Duration(milliseconds: 300),
      () => _convertBloc.convertCurrency(
        from: _currencyFrom.value!.code,
        to: _currencyTo.value!.code,
        amount: amount,
      ),
    );
  }

  void _exchange() {
    FocusScope.of(context).unfocus();
    _amountFromController.text = _amountToController.text;
    _amountToController.text = '';
    final temp = _currencyFrom.value;
    _currencyFrom.value = _currencyTo.value;
    _currencyTo.value = temp;
  }
}
