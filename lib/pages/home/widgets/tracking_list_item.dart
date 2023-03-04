import 'package:flutter/material.dart';
import 'package:ta_chegando/models/ta_chegando_objeto.dart';
import 'package:ta_chegando/services/correios.dart';
import 'package:ta_chegando/utils/datetime_formatter.dart';

class TrackingsListItem extends StatefulWidget {
  final TaChegandoObjeto objeto;
  const TrackingsListItem({
    super.key,
    required this.objeto,
  });

  @override
  State<TrackingsListItem> createState() => _TrackingsListItemWidgetState();
}

class _TrackingsListItemWidgetState extends State<TrackingsListItem> {
  @override
  Widget build(BuildContext context) {
    final obj = widget.objeto;
    return Card(
      child: ExpansionTile(
        title: obj.descricao != null && obj.descricao!.isNotEmpty
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
        subtitle: Text(
          (obj.tracking!.eventos.isEmpty
                  ? null
                  : obj.tracking?.eventos[0]?.unidade?.tipo) ??
              'Sem localização',
        ),
        children: [
          ...((obj.tracking!.eventos.isEmpty
                  ? null
                  : obj.tracking!.eventos.map((evento) {
                      final e = evento!;
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SizedBox(
                                width: 36,
                                height: 36,
                                child: Image.network(
                                    CorreiosUrls.icon(e.urlIcone!)),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateTimeFormatter.shortDateWithTime(
                                      e.dtHrCriado!),
                                ),
                                Text(e.descricao!),
                                Row(
                                  children: [
                                    Text(e.unidade!.tipo, softWrap: true),
                                    if (e.unidadeDestino != null)
                                      const Icon(Icons.arrow_forward),
                                    Text(e.unidadeDestino?.tipo ?? '',
                                        softWrap: true),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList()) ??
              [const Text('Sem eventos')]),
        ],
      ),
    );
  }
}
