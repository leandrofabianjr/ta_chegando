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

  static getDb<T>(String name) {
    return Hive.isBoxOpen(name)
        ? Future.value(Hive.box<T>(name))
        : Hive.openBox<T>(name);
  }

  static Future<Box<TaChegandoObjeto>> get trackings =>
      getDb<TaChegandoObjeto>('trackings');

  static Future get settings => getDb('settings');
}
