import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: FutureBuilder(
        future: Hive.openBox('codes'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error.toString()}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var codes = snapshot.data?.values.toList() ?? [];

          if (codes.isEmpty) {
            return const Center(
              child: Text('Lista vazia'),
            );
          }

          return ListView.builder(
            itemCount: codes.length,
            itemBuilder: (context, index) {
              return TrackingsListItemWidget(code: codes[index]);
            },
          );
        },
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

  Future saveTrackingCode(String code) async {
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
              readOnly: loading,
              decoration: const InputDecoration(
                hintText: 'AA123456785BR',
                label: Text('Código de rastreio'),
              ),
              onSubmitted: (value) async {
                await saveTrackingCode(value);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingsListItemWidget extends StatefulWidget {
  final String code;
  const TrackingsListItemWidget({
    super.key,
    required this.code,
  });

  @override
  State<TrackingsListItemWidget> createState() =>
      _TrackingsListItemWidgetState();
}

class _TrackingsListItemWidgetState extends State<TrackingsListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(widget.code),
        ],
      ),
    );
  }
}
