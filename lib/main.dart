import 'package:flutter/material.dart';
import 'package:test_app/presentation/main_screen/main_screen.dart';

import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple[900]!,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
