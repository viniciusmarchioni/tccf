import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TimesRepository {
  Jogador goleiro = Jogador(EstatisticasMenor());
  List<Jogador> defensores = [];
  List<Jogador> meias = [];
  List<Jogador> atacantes = [];
  List<String> formacoes = [];
  String formacaoSem = "";

  TimesRepository();

  Future<void> getInfo(int idTime) async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5000/jogadores/$idTime'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        goleiro = Jogador(EstatisticasMenor());
        defensores = [];
        meias = [];
        atacantes = [];
        formacoes = [];

        var body = jsonDecode(response.body);

        for (var i in body['formações']) {
          formacoes.add(i.toString());
        }

        goleiro = Jogador.fromJsonAll(body['goleiro'][0]);
        for (var i in body['defensores']) {
          defensores.add(Jogador.fromJsonAll(i));
        }
        for (var i in body['meias']) {
          meias.add(Jogador.fromJsonAll(i));
        }
        for (var i in body['atacantes']) {
          atacantes.add(Jogador.fromJsonAll(i));
        }
      }
    } catch (e) {
      debugPrint("Erro: $e");
    }
  }

  Future<void> updateFormacao(int idTime, String formacao) async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5000/times/teste/$idTime/$formacao'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        goleiro = Jogador(EstatisticasMenor());
        defensores = [];
        meias = [];
        atacantes = [];

        var body = jsonDecode(response.body);

        goleiro = Jogador.fromJsonAll(body['goleiro'][0]);
        for (var i in body['defensores']) {
          defensores.add(Jogador.fromJsonAll(i));
        }
        for (var i in body['meias']) {
          meias.add(Jogador.fromJsonAll(i));
        }
        for (var i in body['atacantes']) {
          atacantes.add(Jogador.fromJsonAll(i));
        }
      }
    } catch (e) {
      debugPrint("Erro: $e");
    }
  }
}

class Jogador {
  String? nome;
  int? id;
  int? idTime;
  String? image;
  bool? lesionado;
  EstatisticasMenor estatisticas;
  String? dataDeNascimento;
  String? nacionalidade;

  Jogador(this.estatisticas);

  Jogador.fromJsonAll(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        nacionalidade = json['nacionalidade'],
        dataDeNascimento = json['data_nacimento'],
        lesionado = json['lesionado'],
        idTime = json['id_time'],
        estatisticas = EstatisticasMenor.fromJsonAll(json['estatisticas']),
        image = json['imagem'];
}

class EstatisticasMenor {
  double? estatistica1;
  double? estatistica2;
  double? estatistica3;

  EstatisticasMenor();

  EstatisticasMenor.fromJsonAll(Map<String, dynamic> json)
      : estatistica1 = json['estatistica1'],
        estatistica2 = json['estatistica2'],
        estatistica3 = json['estatistica3'];
}
