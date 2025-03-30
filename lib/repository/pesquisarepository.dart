import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PesquisaRepository {
  List<Time> times = [];
  List<JogadorTime> jogadores = [];

  PesquisaRepository();

  Future<void> pesquisa(String pesquisa) async {
    times = [];
    jogadores = [];
    try {
      var response = await http
          .get(Uri.parse('http://localhost:5000/pesquisa/$pesquisa'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        times = [];
        var body = jsonDecode(response.body);

        for (var i in body['times']) {
          times.add(Time.fromJsonAll(i));
        }

        for (var i in body['jogadores']) {
          jogadores.add(JogadorTime.fromJsonAll(i));
        }
      }
    } catch (e) {
      //
    }
  }
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

class JogadorTime {
  int? id;
  String? nome;
  String? image;
  String? nomeTime;

  JogadorTime();

  JogadorTime.fromJsonAll(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        image = json['imagem'],
        nomeTime = json['nometime'];
}
