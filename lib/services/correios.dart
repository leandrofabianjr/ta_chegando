// Baseado em https://github.com/FinotiLucas/Correios-Brasil

import 'dart:convert';

import 'package:http/http.dart' as http;

class CorreiosUrls {
  static const proxyappToken =
      'https://proxyapp.correios.com.br/v1/app-validation';
}

class Correios {
  static const requestToken =
      'YW5kcm9pZDtici5jb20uY29ycmVpb3MucHJlYXRlbmRpbWVudG87RjMyRTI5OTc2NzA5MzU5ODU5RTBCOTdGNkY4QTQ4M0I5Qjk1MzU3OA==';

  String? token;
  DateTime? tokenExpiration;

  Future<String> generateToken() async {
    if (token != null &&
        token!.isNotEmpty &&
        tokenExpiration != null &&
        tokenExpiration!.isAfter(DateTime.now())) {
      return Future.value(token);
    }

    final response = await http.post(Uri.parse(CorreiosUrls.proxyappToken),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'requestToken': requestToken}));
    switch (response.statusCode) {
      case 201:
        token = jsonDecode(response.body)?['token'];
        return token!;
      default:
        throw Exception('Falha ao gerar token de acesso aos correios');
    }
  }
}
