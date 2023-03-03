import 'package:flutter/material.dart';
import 'package:ta_chegando/models/ta_chegando_objeto.dart';
import 'package:ta_chegando/services/correios.dart';
import 'package:ta_chegando/services/ta_chegando_trackings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  final trackingsService = TaChegandoTrackings();
  List<TaChegandoObjeto> trackings = [];

  @override
  initState() {
    refreshList();
    super.initState();
  }

  Future<void> refreshList() async {
    setState(() => loading = true);
    trackings = await trackingsService.getAllUpdated();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tá chegando'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const AddTrackingDialog(),
        ).then((value) => setState(() => {})),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: refreshList,
              child: trackings.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(
                          height: 200,
                          child: Center(child: Text('Lista vazia')),
                        )
                      ],
                    )
                  : ListView.builder(
                      itemCount: trackings.length,
                      itemBuilder: (context, index) =>
                          TrackingsListItemWidget(objeto: trackings[index]),
                    ),
            ),
    );
  }
}

class AddTrackingDialog extends StatefulWidget {
  const AddTrackingDialog({super.key});

  @override
  State<AddTrackingDialog> createState() => _AddTrackingDialogState();
}

class _AddTrackingDialogState extends State<AddTrackingDialog> {
  final Correios api = Correios();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final tracking = TaChegandoObjeto();

  Future<void> saveTrackingCode() async {
    setState(() => loading = true);
    await TaChegandoTrackings().add(tracking);
  }

  submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    saveTrackingCode().then((_) {
      Navigator.of(context).pop(true);
    }).catchError(
      (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não encontrei seu pacote. Esse código tá certo?'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading) const CircularProgressIndicator(),
              TextFormField(
                autofocus: true,
                readOnly: loading,
                decoration: const InputDecoration(
                  hintText: 'AA123456785BR',
                  label: Text('Código de rastreio'),
                ),
                onFieldSubmitted: (_) => submitForm(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(
                        r'^[A-Z]{2}[0-9]{9}[A-Z]{2}$',
                        caseSensitive: false,
                      ).hasMatch(value)) {
                    return 'Esse código é inválido';
                  }
                  tracking.codigo = value;
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
                validator: (value) {
                  tracking.descricao = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackingsListItemWidget extends StatefulWidget {
  final TaChegandoObjeto objeto;
  const TrackingsListItemWidget({
    super.key,
    required this.objeto,
  });

  @override
  State<TrackingsListItemWidget> createState() =>
      _TrackingsListItemWidgetState();
}

class _TrackingsListItemWidgetState extends State<TrackingsListItemWidget> {
  late final Correios api;

  @override
  void initState() {
    api = Correios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final obj = widget.objeto;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: ExpansionTile(
          title: obj.descricao != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(obj.descricao!),
                    Text(
                      '(${obj.codigo!})',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
              : Text(obj.codigo!),
          subtitle: Text(obj.tracking!.eventos[0]!.unidade!.tipo),
          children: [
            ...obj.tracking!.eventos.map((evento) {
              return Text(evento!.unidade!.tipo);
            }).toList(),
          ],
        ),
      ),
    );
  }
}
