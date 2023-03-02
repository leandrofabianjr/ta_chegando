import 'package:flutter/material.dart';
import 'package:ta_chegando/test_page.dart';

void main() {
  runApp(const TaChegandoApp());
}

class TaChegandoApp extends StatelessWidget {
  const TaChegandoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tá chegando',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestPage(),
    );
  }
}
