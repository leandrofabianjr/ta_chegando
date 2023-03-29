import 'dart:convert';

import 'package:ta_chegando/services/correios.dart';

class TaChegandoObjeto {
  String codigo;
  String? descricao;
  Map<dynamic, dynamic>? json;
  String? errorMessage;
  DateTime createdAt;
  bool isDeleted;
  DateTime? deletedAt;

  CorreiosObject? get tracking => CorreiosObject.fromJson(json);

  TaChegandoObjeto({
    required this.codigo,
    this.descricao,
    this.json,
    this.errorMessage,
    createdAt,
    isDeleted,
    this.deletedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        isDeleted = isDeleted ?? false;

  delete() {
    isDeleted = true;
    deletedAt = DateTime.now();
  }

  static TaChegandoObjeto? fromJson(json) {
    if (json == null) return null;

    return TaChegandoObjeto(
      codigo: json['codigo'],
      descricao: json['descricao'],
      json: json['json'],
      errorMessage: json['errorMessage'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      isDeleted: json['isDeleted'],
      deletedAt: DateTime.tryParse(json['deletedAt'] ?? ''),
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
      'createdAt': createdAt.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return jsonEncode(json);
  }
}
