import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PesquisaAvancadaRepository {
  List<dynamic> resultados = [];
  final Map<String, String> _map = {
    "posicao": "",
    "formacao": "",
    "gols": "false",
    "desarmes": "false",
    "assistencias": "false",
    "passes_certos": "false",
    "passes_chaves": "false",
    "faltas_sofridas": "false",
    "dribles_completos": "false",
    "chutes_no_gol": "false",
    "bloqueados": "false",
  };
  PesquisaAvancadaRepository();
  Future<void> pesquisa(Map<String, String> param) async {
    if (mapEquals(param, _map)) {
      resultados = [];
      return;
    }
    try {
      var response = await http.get(
          Uri.parse("http://localhost:5000/pesquisaavancada/"),
          headers: param);

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List<dynamic> resultadosProvisorios = body['resultado'];

        resultadosProvisorios
            .sort((a, b) => b['solicitacao'].compareTo(a['solicitacao']));

        resultados = resultadosProvisorios;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
