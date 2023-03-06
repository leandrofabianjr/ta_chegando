import 'package:flutter/material.dart';
import 'package:ta_chegando/models/ta_chegando_objeto.dart';
import 'package:ta_chegando/pages/home/widgets/add_tracking_dialog.dart';
import 'package:ta_chegando/pages/home/widgets/tracking_list_item.dart';
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
        ).then((success) {
          if (success) refreshList();
        }),
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
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemCount: trackings.length,
                      itemBuilder: (context, index) =>
                          TrackingsListItem(objeto: trackings[index]),
                    ),
            ),
    );
  }
}
