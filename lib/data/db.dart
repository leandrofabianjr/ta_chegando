import 'package:hive_flutter/adapters.dart';
import 'package:ta_chegando/data/adapters/ta_chegando_objeto_adapter.dart';
import 'package:ta_chegando/data/adapters/ta_chegando_settings_adapter.dart';
import 'package:ta_chegando/models/ta_chegando_objeto.dart';

class Db {
  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaChegandoObjetoAdapter());
    Hive.registerAdapter(TaChegandoSettingsAdapter());
  }

  static Future<Box<TaChegandoObjeto>> get trackings =>
      Hive.openBox<TaChegandoObjeto>('trackings');

  static Future<Box<TaChegandoObjeto>> get settings =>
      Hive.openBox<TaChegandoObjeto>('settings');
}
