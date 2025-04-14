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
  Aproveitamento aproveitamento = Aproveitamento();
  List<EstatisticasMenor> medias = [];
  Time infoTime = Time();

  TimesRepository();

  Future<void> getInfo(int idTime) async {
    try {
      var response = await http
          .get(Uri.parse('http://localhost:5000/times/$idTime'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        goleiro = Jogador(EstatisticasMenor());
        defensores.clear();
        meias.clear();
        atacantes.clear();
        formacoes.clear();
        infoTime = Time();

        var body = jsonDecode(response.body);

        infoTime = Time.fromJsonAll(body['info']);

        for (var i in body['formações']) {
          formacoes.add(i.toString());
        }

        for (var i in body['goleiro']) {
          goleiro = Jogador.fromJsonAll(i);
        }

        for (var i in body['defensores']) {
          defensores.add(Jogador.fromJsonAll(i));
        }

        for (var i in body['meias']) {
          meias.add(Jogador.fromJsonAll(i));
        }

        for (var i in body['atacantes']) {
          atacantes.add(Jogador.fromJsonAll(i));
        }

        aproveitamento = Aproveitamento.fromJsonAll(body['aproveitamento']);
      }

      response = await http
          .get(Uri.parse('http://localhost:5000/jogadores/medias/'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        medias.add(EstatisticasMenor.fromJsonAll(body['media_defensores']));
        medias.add(EstatisticasMenor.fromJsonAll(body['media_meias']));
        medias.add(EstatisticasMenor.fromJsonAll(body['media_atacantes']));
      }
    } catch (e) {
      debugPrint("Erro get info: $e");
    }
  }

  Future<void> updateFormacao(int idTime, String formacao) async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5000/times/$idTime/$formacao'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        goleiro = Jogador(EstatisticasMenor());
        defensores.clear();
        meias.clear();
        atacantes.clear();

        var body = jsonDecode(response.body);

        for (var i in body['goleiro']) {
          goleiro = Jogador.fromJsonAll(i);
        }
        for (var i in body['defensores']) {
          defensores.add(Jogador.fromJsonAll(i));
        }
        for (var i in body['meias']) {
          meias.add(Jogador.fromJsonAll(i));
        }
        for (var i in body['atacantes']) {
          atacantes.add(Jogador.fromJsonAll(i));
        }
        aproveitamento = Aproveitamento.fromJsonAll(body['aproveitamento']);
      }
    } catch (e) {
      debugPrint("Erro updateFormacao: $e");
    }
  }
}

class Aproveitamento {
  int vitorias = 0;
  int empates = 0;
  int derrotas = 0;

  Aproveitamento();

  Aproveitamento.fromJsonAll(Map<String, dynamic> json) {
    vitorias = json['vitorias'] ?? 0;
    empates = json['empates'] ?? 0;
    derrotas = json['derrotas'] ?? 0;
  }

  int getPartidas() => vitorias + empates + derrotas;

  double getAproveitamento() {
    return ((vitorias * 3 + empates) / (getPartidas() * 3)) * 100;
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

  List<double> getLista() =>
      [estatistica1 ?? 0, estatistica2 ?? 0, estatistica3 ?? 0];
}

class Time {
  int? id;
  String? nome;
  String? logo;

  Time();

  Time.fromJsonAll(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        logo = json['logo'];
}
