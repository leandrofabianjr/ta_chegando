import 'package:flutter/material.dart';
import 'package:ta_chegando/data/db.dart';
import 'package:ta_chegando/pages/home/home_page.dart';

void main() async {
  await Db.init();
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
