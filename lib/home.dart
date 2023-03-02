import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  String retorno = 'Dados aqui';

  loading([bool state = true]) {
    setState(() => _loading = state);
  }

  request() async {
    loading();
    await Future.delayed(const Duration(seconds: 2));
    loading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tá chegando'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(retorno)],
                ),
              ),
              ElevatedButton(
                onPressed: _loading ? null : request,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Consultar'),
              ),
            ],
          )),
    );
  }
}
