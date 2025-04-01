import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PesquisaAvancadaRepository {
  List<dynamic> resultados = [];

  PesquisaAvancadaRepository();
  Future<void> pesquisa(Map<String, String> param) async {
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
