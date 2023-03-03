import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ta_chegando/models/ta_chegando_settings.dart';

class TaChegandoSettingsAdapter extends TypeAdapter<TaChegandoSettings> {
  @override
  int get typeId => 0;

  @override
  TaChegandoSettings read(BinaryReader reader) {
    final json = jsonDecode(reader.read());
    return TaChegandoSettings.fromJson(json)!;
  }

  @override
  void write(BinaryWriter writer, TaChegandoSettings obj) {
    final json = obj.toJson();
    writer.write(json);
  }
}
