import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TimesRepository {
  Jogador goleiro = Jogador(Estatisticas());
  List<Jogador> defensores = [];
  List<Jogador> meias = [];
  List<Jogador> atacantes = [];
  List<String> formacoes = [];
  String formacaoSem = "";

  TimesRepository();

  Future<void> updateJogadores(int idTeam) async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5000/jogadores/$idTeam/'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        defensores = [];
        meias = [];
        atacantes = [];

        goleiro =
            Jogador.fromJsonAll(jsonDecode(response.body)[0]['goleiros'][0]);
        var def = jsonDecode(response.body)[1]['defensores'];
        var mei = jsonDecode(response.body)[2]['meias'];
        var atk = jsonDecode(response.body)[3]['atacantes'];
        formacaoSem = jsonDecode(response.body)[4]['formacao'];

        for (var j in def) {
          defensores.add(Jogador.fromJsonAll(j));
        }
        for (var j in mei) {
          meias.add(Jogador.fromJsonAll(j));
        }
        for (var j in atk) {
          atacantes.add(Jogador.fromJsonAll(j));
        }
      }
    } catch (e) {
      print("Erro" + e.toString());
      //
    }
  }

  Future<void> updateJogadoresFormacao(int idTeam, String formacao) async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5000/jogadores/$idTeam/$formacao'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        defensores = [];
        meias = [];
        atacantes = [];

        var def = jsonDecode(response.body)[1]['defensores'];
        var mei = jsonDecode(response.body)[2]['meias'];
        var atk = jsonDecode(response.body)[3]['atacantes'];

        for (var j in def) {
          defensores.add(Jogador.fromJsonAll(j));
        }
        for (var j in mei) {
          meias.add(Jogador.fromJsonAll(j));
        }
        for (var j in atk) {
          atacantes.add(Jogador.fromJsonAll(j));
        }
      }
    } catch (e) {
      //print("Erro" + e.toString());
      //
    }
  }

  Future<List<String>> updateFormacoes(int idTeam) async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5000/times/$idTeam'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body)['formacoes'];
        for (String i in json) {
          formacoes.add(i);
        }
      }
    } catch (e) {
      //
    }
    return formacoes;
  }
}

class Jogador {
  String? nome;
  int? id;
  int? idTime;
  String? image;
  bool? lesionado;
  Estatisticas estatisticas;
  String? dataDeNacimento;
  String? nacionalidade;

  Jogador(this.estatisticas);

  Jogador.fromJsonAll(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        nacionalidade = json['nacionalidade'],
        dataDeNacimento = json['data_nacimento'],
        lesionado = json['lesionado'],
        idTime = json['id_time'],
        estatisticas = Estatisticas.fromJsonAll(json['estatisticas']),
        image = json['imagem'];
}

class Estatisticas {
  double? estatistica1;
  double? estatistica2;
  double? estatistica3;

  Estatisticas();

  Estatisticas.fromJsonAll(Map<String, dynamic> json)
      : estatistica1 = json['estatistica1'],
        estatistica2 = json['estatistica2'],
        estatistica3 = json['estatistica3'];
}

/*

Games.fromJsonAll(Map<String, dynamic> json)
      : id = json['id'],
        team1name = json['team1'],
        team2name = json['team2'],
        team1score = json['score1'],
        team2score = json['score2'],
        country1 = json['country1'],
        country2 = json['country2'],
        date = DateTime.parse(json['date']),
        championship = json['championship'],
        rate = double.parse(json['rate']),
        type = _toGameType(json['type']);


 */