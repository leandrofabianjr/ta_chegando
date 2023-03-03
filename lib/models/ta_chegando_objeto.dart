import 'package:ta_chegando/services/correios.dart';

class TaChegandoObjeto {
  String codigo;
  String? descricao;
  CorreiosObject objeto;

  TaChegandoObjeto({
    required this.codigo,
    this.descricao,
    required this.objeto,
  });

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'descricao': descricao,
      'objeto': objeto.toJson(),
    };
  }
}
