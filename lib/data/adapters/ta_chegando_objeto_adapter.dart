import 'package:hive/hive.dart';
import 'package:ta_chegando/models/ta_chegando_objeto.dart';

class TaChegandoObjetoAdapter extends TypeAdapter<TaChegandoObjeto> {
  @override
  int get typeId => 1;

  @override
  TaChegandoObjeto read(BinaryReader reader) {
    return TaChegandoObjeto.fromJson(reader.read())!;
  }

  @override
  void write(BinaryWriter writer, TaChegandoObjeto obj) {
    final json = obj.toJson();
    writer.write(json);
  }
}
