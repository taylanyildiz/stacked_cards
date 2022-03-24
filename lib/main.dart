import 'package:flutter/material.dart';
import 'screens/screens.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stacked Cards Example',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffCC5EBA),
        ),
      ),
      home: const HomeScreen(title: 'Stacked Cards'),
    );
  }
}
