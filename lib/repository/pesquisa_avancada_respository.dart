import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:scout/util/util.dart';

class PesquisaAvancadaRepository {
  List<dynamic> resultados = [];

  PesquisaAvancadaRepository();
  Future<void> pesquisa(Map<String, String> param) async {
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
      var response = await http.get(Uri.parse("$endereco/pesquisaavancada/"),
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
