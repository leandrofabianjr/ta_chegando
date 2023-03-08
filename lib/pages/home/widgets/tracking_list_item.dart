import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ta_chegando/models/ta_chegando_objeto.dart';
import 'package:ta_chegando/services/correios.dart';
import 'package:ta_chegando/services/ta_chegando_trackings.dart';
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (obj.errorMessage != null)
              Text(
                obj.errorMessage!,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            obj.descricao != null && obj.descricao!.isNotEmpty
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(obj.descricao!),
                          Text(
                            '(${obj.codigo})',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  )
                : Text(obj.codigo),
          ],
        ),
        subtitle: obj.tracking!.eventos.isEmpty
            ? null
            : Text(obj.tracking!.eventos[0]!.descricao ?? ''),
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
                                  CorreiosUrls.icon(e.urlIcone!),
                                ),
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'de',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Column(
                                        children: [
                                          Text(e.unidade?.tipo ?? ''),
                                          Text((e.unidade?.endereco ??
                                                  e.unidade?.nome ??
                                                  '')
                                              .toString()),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (e.unidadeDestino != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'para',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Column(
                                          children: [
                                            Text(e.unidadeDestino?.tipo ?? ''),
                                            Text((e.unidadeDestino?.endereco ??
                                                    e.unidadeDestino?.nome ??
                                                    '')
                                                .toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList()) ??
              [const Text('Sem eventos')]),
          Row(
            children: [
              if (kDebugMode)
                TextButton(
                  onPressed: () async {
                    Clipboard.setData(ClipboardData(text: obj.toString()));
                  },
                  child: const Text('Copiar'),
                ),
              TextButton.icon(
                onPressed: () async {
                  TaChegandoTrackings().delete(obj.codigo);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Remover',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
