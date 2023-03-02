import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ta_chegando/pages/home_page.dart';

void main() async {
  await Hive.initFlutter();
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
      home: const HomePage(),
    );
  }
}
