import 'package:flutter/material.dart';
import 'package:ta_chegando/services/correios.dart';
import 'package:ta_chegando/services/ta_chegando_trackings.dart';

class AddTrackingDialog extends StatefulWidget {
  const AddTrackingDialog({super.key});

  @override
  State<AddTrackingDialog> createState() => _AddTrackingDialogState();
}

class _AddTrackingDialogState extends State<AddTrackingDialog> {
  final Correios api = Correios();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final codigoCtrl = TextEditingController();
  final descricaoCtrl = TextEditingController();
  String? errorMessage;

  Future<void> saveTrackingCode() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });
    await TaChegandoTrackings().add(
      codigo: codigoCtrl.text,
      descricao: descricaoCtrl.text,
    );
  }

  submitForm() {
    if (!_formKey.currentState!.validate()) return;

    saveTrackingCode().then((_) {
      Navigator.of(context).pop(true);
    }).catchError(
      (err) {
        setState(() {
          loading = false;
          errorMessage = err.toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Novo rastreio'),
      actions: [
        TextButton(
            onPressed: loading ? null : () => Navigator.of(context).pop(false),
            child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: loading ? null : submitForm,
          child: const Text('Adicionar'),
        ),
      ],
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: loading
              ? const Center(
                  heightFactor: 1,
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    TextFormField(
                      autofocus: true,
                      readOnly: loading,
                      decoration: const InputDecoration(
                        hintText: 'AA123456785BR',
                        label: Text('Código de rastreio'),
                      ),
                      onFieldSubmitted: (_) => submitForm(),
                      controller: codigoCtrl,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(
                              r'^[A-Z]{2}[0-9]{9}[A-Z]{2}$',
                              caseSensitive: false,
                            ).hasMatch(value)) {
                          return 'Esse código é inválido';
                        }
                      },
                    ),
                    TextFormField(
                      autofocus: true,
                      readOnly: loading,
                      decoration: const InputDecoration(
                        hintText: 'O que tá chegando?',
                        label: Text('Descrição (opcional)'),
                      ),
                      onFieldSubmitted: (_) => submitForm(),
                      controller: descricaoCtrl,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
