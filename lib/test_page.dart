import 'package:flutter/material.dart';
import 'package:ta_chegando/services/correios.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool _loading = false;
  String dados = 'Dados aqui';
  late Correios api;

  @override
  initState() {
    api = Correios();

    super.initState();
  }

  loading([bool state = true]) {
    setState(() => _loading = state);
  }

  request() async {
    loading();
    try {
      final object = await api.fetchTrackingService('OT610216475BR');
      setState(() {
        dados = object.toString();
      });
    } catch (e) {
      dados = e.toString();
    }
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
                  children: [Text(dados)],
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
