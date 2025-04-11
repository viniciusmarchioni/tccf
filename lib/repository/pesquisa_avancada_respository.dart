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
    "passes-certos": "false",
    "passes-chaves": "false",
    "faltas-sofridas": "false",
    "dribles-completos": "false",
    "chutes-no-gol": "false",
    "bloqueados": "false",
  };
  final _formatoPosicao = {
    "Atacante": "F",
    "Meia": "M",
    "Defensor": "D",
    "Goleiro": "G",
    "": ""
  };

  PesquisaAvancadaRepository();
  Future<void> pesquisa(Map<String, String> param) async {
    print("======================================");
    print("param: \n " "posicao: ${param['posicao']}");

    if (param['formacao'] == "" &&
        param['posicao'] == "" &&
        param['gols'] == 'false' &&
        param['desarmes'] == 'false' &&
        param['assistencias'] == 'false' &&
        param['passes-certos'] == 'false' &&
        param['passes-chaves'] == 'false' &&
        param['faltas-sofridas'] == 'false' &&
        param['dribles-completos'] == 'false' &&
        param['chutes-no-gol'] == 'false' &&
        param['bloqueados'] == 'false') {
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
