import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ta_chegando/services/correios.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  late final Correios api;
  List<CorreiosObject> objetos = [];

  @override
  initState() {
    api = Correios();
    super.initState();
    refreshList();
  }

  Future<void> refreshList() async {
    setState(() => loading = true);

    final codesBox = await Hive.openBox('codes');
    final codes = codesBox.values.toList();
    codesBox.close();

    objetos.clear();
    for (var code in codes) {
      final objeto = await api.fetchTrackingService(code);
      if (objeto != null) {
        objetos.add(objeto);
      }
    }

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
              child: objetos.isEmpty
                  ? ListView(
                      children: const [Center(child: Text('Lista vazia'))],
                    )
                  : ListView.builder(
                      itemCount: objetos.length,
                      itemBuilder: (context, index) =>
                          TrackingsListItemWidget(objeto: objetos[index]),
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
  bool loading = false;

  Future<void> saveTrackingCode(String code) async {
    setState(() => loading = true);

    var codesBox = await Hive.openBox('codes');
    codesBox.add(code);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading) const CircularProgressIndicator(),
            TextField(
              autofocus: true,
              readOnly: loading,
              decoration: const InputDecoration(
                hintText: 'AA123456785BR',
                label: Text('Código de rastreio'),
              ),
              onSubmitted: (value) => saveTrackingCode(value).then(
                (_) => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingsListItemWidget extends StatefulWidget {
  final CorreiosObject objeto;
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
          title: Text(obj.codObjeto),
          subtitle: Text(obj.eventos[0]!.unidade!.tipo),
          children: [
            Text(obj.codObjeto),
            ...obj.eventos.map((evento) {
              return Text(evento!.unidade!.tipo);
            }).toList(),
          ],
        ),
      ),
    );
  }
}
