// Baseado em https://github.com/FinotiLucas/Correios-Brasil

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ta_chegando/data/db.dart';

class CorreiosUrls {
  static String proxyApp(url) => 'https://proxyapp.correios.com.br/v1/$url';
  static String proxyappToken() => proxyApp('app-validation');
  static String proxyappRastrear(String code) => proxyApp('sro-rastro/$code');
  static String icon(String url) =>
      'https://rastreamento.correios.com.br/static/rastreamento-internet/imgs/${url.substring(url.lastIndexOf('/') + 1)}';
}

class Correios {
  static const requestToken =
      'YW5kcm9pZDtici5jb20uY29ycmVpb3MucHJlYXRlbmRpbWVudG87RjMyRTI5OTc2NzA5MzU5ODU5RTBCOTdGNkY4QTQ4M0I5Qjk1MzU3OA==';

  String? token;
  DateTime? tokenExpiration;

  Future<Map<String, String>> generateHeaders({bool withToken = true}) async {
    final headers = {
      'content-type': 'application/json',
    };
    if (withToken) {
      headers.addAll({'app-check-token': await generateToken()});
    }
    return headers;
  }

  Future<String> generateToken() async {
    if (token == null) {
      final configsBox = (await Hive.openBox('configs'));
      token = configsBox.get('token');
    }

    if (token != null &&
        token!.isNotEmpty &&
        tokenExpiration != null &&
        tokenExpiration!.isAfter(DateTime.now())) {
      return Future.value(token);
    }

    final response = await http.post(
      Uri.parse(CorreiosUrls.proxyappToken()),
      headers: await generateHeaders(withToken: false),
      body: jsonEncode({'requestToken': requestToken}),
    );
    switch (response.statusCode) {
      case 201:
        token = jsonDecode(response.body)?['token'];
        final decoded = JwtDecoder.decode(token!);
        final millisecondsSinceEpoch =
            decoded['exp'] * 1000 - 120000; // 120 segundos de margem
        tokenExpiration =
            DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

        (await Db.settings).put('token', token);

        return token!;
      default:
        throw Exception('Falha ao gerar token de acesso aos correios');
    }
  }

  Future<Map<dynamic, dynamic>> fetchTrackingService(String code) async {
    final upperCode = code.toUpperCase();
    final response = await http.get(
      Uri.parse(CorreiosUrls.proxyappRastrear(upperCode)),
      headers: await generateHeaders(),
    );
    switch (response.statusCode) {
      case 200:
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final objeto = json['objetos'][0] as Map;
        if (!objeto.containsKey('eventos') &&
            objeto.containsKey('mensagem') &&
            (objeto['mensagem'] as String).contains('SRO-020:')) {
          throw CorreiosNotFoundException();
        }
        return objeto;
      default:
        throw Exception('Falha ao rastrear código de encomenda');
    }
  }
}

class CorreiosEndereco {
  String cidade;
  String uf;

  CorreiosEndereco({
    required this.cidade,
    required this.uf,
  });

  static CorreiosEndereco? fromJson(Map? json) {
    if (json == null || json.isEmpty) return null;

    return CorreiosEndereco(
      cidade: json['cidade'],
      uf: json['uf'],
    );
  }

  @override
  String toString() {
    return '$cidade - $uf';
  }
}

class CorreiosUnidade {
  String tipo;
  CorreiosEndereco? endereco;
  String? codSro;
  String? nome;

  CorreiosUnidade({
    required this.tipo,
    this.endereco,
    this.codSro,
    this.nome,
  });

  static CorreiosUnidade? fromJson(json) {
    if (json == null || json.isEmpty) return null;

    return CorreiosUnidade(
      tipo: json['tipo'],
      endereco: CorreiosEndereco.fromJson(json['endereco']),
      codSro: json['codSro'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endereco': endereco,
      'tipo': tipo,
      'codSro': codSro,
      'nome': nome,
    };
  }
}

class CorreiosTipoPostal {
  String? categoria;
  String? descricao;
  String? sigla;

  CorreiosTipoPostal({
    required this.categoria,
    required this.descricao,
    required this.sigla,
  });

  static CorreiosTipoPostal? fromJson(json) {
    if (json == null || json.isEmpty) return null;

    return CorreiosTipoPostal(
      categoria: json['categoria'],
      descricao: json['descricao'],
      sigla: json['sigla'],
    );
  }

  Map<String, String?> toJson() {
    return {
      'categoria': categoria,
      'descricao': descricao,
      'sigla': sigla,
    };
  }
}

class CorreiosObject {
  String codObjeto;
  List<CorreiosObjectEvent?> eventos;
  String? modalidade;
  CorreiosTipoPostal? tipoPostal;
  bool? habilitaAutoDeclaracao;
  bool? permiteEncargoImportacao;
  bool? habilitaPercorridaCarteiro;
  bool? bloqueioObjeto;
  bool? possuiLocker;
  bool? habilitaLocker;
  bool? habilitaCrowdshipping;

  CorreiosObject({
    required this.codObjeto,
    required this.eventos,
    this.modalidade,
    this.tipoPostal,
    this.habilitaAutoDeclaracao,
    this.permiteEncargoImportacao,
    this.habilitaPercorridaCarteiro,
    this.bloqueioObjeto,
    this.possuiLocker,
    this.habilitaLocker,
    this.habilitaCrowdshipping,
  });

  static CorreiosObject? fromJson(json) {
    if (json == null || json.isEmpty) return null;

    return CorreiosObject(
      codObjeto: json['codObjeto'],
      eventos: CorreiosObjectEvent.fromJsonList(json['eventos']),
      modalidade: json['modalidade'],
      tipoPostal: CorreiosTipoPostal.fromJson(json['tipoPostal']),
      habilitaAutoDeclaracao: json['habilitaAutoDeclaracao'],
      permiteEncargoImportacao: json['permiteEncargoImportacao'],
      habilitaPercorridaCarteiro: json['habilitaPercorridaCarteiro'],
      bloqueioObjeto: json['bloqueioObjeto'],
      possuiLocker: json['possuiLocker'],
      habilitaLocker: json['habilitaLocker'],
      habilitaCrowdshipping: json['habilitaCrowdshipping'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codObjeto': codObjeto,
      'eventos': CorreiosObjectEvent.toJsonList(eventos),
      'modalidade': modalidade,
      'tipoPostal': tipoPostal?.toJson(),
      'habilitaAutoDeclaracao': habilitaAutoDeclaracao,
      'permiteEncargoImportacao': permiteEncargoImportacao,
      'habilitaPercorridaCarteiro': habilitaPercorridaCarteiro,
      'bloqueioObjeto': bloqueioObjeto,
      'possuiLocker': possuiLocker,
      'habilitaLocker': habilitaLocker,
      'habilitaCrowdshipping': habilitaCrowdshipping,
    };
  }
}

class CorreiosObjectEvent {
  String? codigo;
  String? descricao;
  DateTime? dtHrCriado;
  String? tipo;
  CorreiosUnidade? unidade;
  CorreiosUnidade? unidadeDestino;
  String? urlIcone;

  CorreiosObjectEvent({
    this.codigo,
    this.descricao,
    this.dtHrCriado,
    this.tipo,
    this.unidade,
    this.unidadeDestino,
    this.urlIcone,
  });

  static CorreiosObjectEvent? fromJson(json) {
    if (json == null || json.isEmpty) return null;

    return CorreiosObjectEvent(
      codigo: json['codigo'],
      descricao: json['descricao'],
      dtHrCriado: DateTime.parse(json['dtHrCriado']),
      tipo: json['tipo'],
      unidade: CorreiosUnidade.fromJson(json['unidade']),
      unidadeDestino: CorreiosUnidade.fromJson(json['unidadeDestino']),
      urlIcone: json['urlIcone'],
    );
  }

  static List<CorreiosObjectEvent?> fromJsonList(List? jsonList) {
    if (jsonList == null || jsonList.isEmpty) return [];

    return jsonList.map((json) => CorreiosObjectEvent.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'descricao': descricao,
      'dtHrCriado': dtHrCriado,
      'tipo': tipo,
      'unidade': unidade?.toJson(),
      'unidadeDestino': unidadeDestino?.toJson(),
      'urlIcone': urlIcone,
    };
  }

  static List<Map<String, dynamic>?> toJsonList(
    List<CorreiosObjectEvent?> objetos,
  ) {
    return objetos.map((objeto) => objeto?.toJson()).toList();
  }
}

class CorreiosTrackingException implements Exception {
  @override
  String toString() => 'Não foi possível rastrear o objeto';
}

class CorreiosNotFoundException implements Exception {
  @override
  String toString() => 'Objeto não encontrado';
}
