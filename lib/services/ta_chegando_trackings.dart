import 'package:ta_chegando/data/db.dart';
import 'package:ta_chegando/models/ta_chegando_objeto.dart';
import 'package:ta_chegando/services/correios.dart';

class TaChegandoTrackings {
  late final Correios api;

  TaChegandoTrackings() : api = Correios();

  Future<void> add({
    required String codigo,
    String? descricao,
  }) async {
    try {
      final json = await api.fetchTrackingService(codigo);
      final tracking = TaChegandoObjeto(
        codigo: codigo,
        descricao: descricao,
        json: json,
      );
      final trackingsDb = await Db.trackings;
      trackingsDb.put(tracking.codigo, tracking);
    } catch (_) {
      rethrow;
    }
  }

  Future<List<TaChegandoObjeto>> getAllUpdated() async {
    final trackingsDb = await Db.trackings;
    final trackings = trackingsDb.values.toList();

    for (final t in trackings) {
      try {
        t.json = await api.fetchTrackingService(t.codigo);
        t.errorMessage = null;
      } catch (e) {
        t.errorMessage = e.toString();
      }
      trackingsDb.put(t.codigo, t);
    }

    return trackings;
  }

  Future<void> delete(String codigo) async {
    (await Db.trackings).get(codigo)!.delete();
  }
}
