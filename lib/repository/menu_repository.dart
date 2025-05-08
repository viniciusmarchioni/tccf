import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scout/util/util.dart';

class MenuRepository {
  List<JogadoresDestaque> jogadoresDestaque = [];
  List<Partida> ultimasPartidas = [];
  List<Partida> proximasPartidas = [];

  MenuRepository();

  Future<void> init() async {
    try {
      var response = await http
          .get(Uri.parse('$endereco/jogadores/destaques'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        jogadoresDestaque = [];
        var body = jsonDecode(response.body);

        for (var i in body['jogadores']) {
          jogadoresDestaque.add(JogadoresDestaque.fromJsonAll(i));
        }
      }

      response = await http
          .get(Uri.parse('$endereco/jogos/ultimos'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        ultimasPartidas = [];
        var body = jsonDecode(response.body);

        for (var i in body['jogos']) {
          ultimasPartidas.add(Partida.fromJsonAll(i));
        }
        ultimasPartidas.sort(
          (a, b) => b.data!.compareTo(a.data!),
        );
      }

      response = await http
          .get(Uri.parse('$endereco/jogos/proximos'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        proximasPartidas = [];
        var body = jsonDecode(response.body);

        for (var i in body['jogos']) {
          proximasPartidas.add(Partida.fromJsonAll(i));
        }
        proximasPartidas.sort(
          (a, b) => b.data!.compareTo(a.data!),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class JogadoresDestaque {
  String? nome;
  String? imagem;
  String? nomeTime;
  double? nota;
  int? id;

  JogadoresDestaque.fromJsonAll(Map<String, dynamic> json)
      : id = json['id'],
        imagem = json['imagem'],
        nome = json['nome'],
        nomeTime = json['nome_time'],
        nota = json['nota'];
}

class Partida {
  int? idMandante;
  int? idVisitante;
  String? nomeMandante;
  String? nomeVisitante;
  int? golsMandante;
  int? golsVisitante;
  String? logoMandante;
  String? logoVisitante;
  DateTime? data;
  final DateFormat _dataF = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");

  Partida.fromJsonAll(Map<String, dynamic> json) {
    idMandante = json['mandante']['id'];
    nomeMandante = json['mandante']['nome'];
    logoMandante = json['mandante']['logo'];
    golsMandante = json['mandante']['gols'];
    idVisitante = json['visitante']['id'];
    nomeVisitante = json['visitante']['nome'];
    logoVisitante = json['visitante']['logo'];
    golsVisitante = json['visitante']['gols'];
    data = _dataF.parse(json['data']);
  }
}
