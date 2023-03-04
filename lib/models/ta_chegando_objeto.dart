import 'dart:convert';

import 'package:ta_chegando/services/correios.dart';

class TaChegandoObjeto {
  String? codigo;
  String? descricao;
  Map<dynamic, dynamic>? json;
  String? errorMessage;

  CorreiosObject? get tracking => CorreiosObject.fromJson(json);

  TaChegandoObjeto({
    this.codigo,
    this.descricao,
    this.json,
    this.errorMessage,
  });

  static TaChegandoObjeto? fromJson(json) {
    if (json == null) return null;

    return TaChegandoObjeto(
      codigo: json['codigo'],
      descricao: json['descricao'],
      json: json['json'],
      errorMessage: json['errorMessage'],
    );
  }

  static List<TaChegandoObjeto?> fromJsonList(List? jsonList) {
    if (jsonList == null) return [];

    return jsonList.map((json) => TaChegandoObjeto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'descricao': descricao,
      'json': json,
      'errorMessage': errorMessage,
    };
  }

  @override
  String toString() {
    return jsonEncode(json);
  }
}
