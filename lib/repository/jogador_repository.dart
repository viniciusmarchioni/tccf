import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'teamsrepository.dart';

class JogadorRepository {
  Jogador jogador = Jogador(EstatisticasMenor());
  String? nomeTime;
  double? nota;
  String? formacaoFavorita;
  String? posicaoFavorita;
  Estatisticas? estatisticasPosFav;
  Estatisticas? estatisticasFormFav;
  Estatisticas? estatisticas;
  double? notaAvgForm;
  Estatisticas? mediaGeral;
  int? partidasJogadas;
  List<Destaque> destaques = [];

  List<String> formacoes = [];

  JogadorRepository();

  Future<void> getInfo(int idJogador) async {
    try {
      var response = await http
          .get(Uri.parse("http://localhost:5000/jogadores/$idJogador"))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        jogador = Jogador.fromJsonAll(body);
        nomeTime = body['nome_time'];
        nota = body['nota'];
        formacaoFavorita = body['formacao_favorita'];
        posicaoFavorita = body['posicao_favorita'];
        estatisticas = Estatisticas.fromJsonAll(body['estatisticas']);
        partidasJogadas = body['partidas_jogadas'];
        estatisticasPosFav =
            Estatisticas.fromJsonAll(body['estatisticas_posicao_favorita']);
        estatisticasFormFav =
            Estatisticas.fromJsonAll(body['estatisticas_formacao_favorita']);
        formacoes = [];
        for (String? i in body['formacoes']) {
          if (i != null) {
            formacoes.add(i);
          }
        }

        destaques = [];
        for (var i in body['destaques']) {
          destaques.add(Destaque.fromJsonAll(i));
        }
        var response2 = await http
            .get(Uri.parse(
                "http://localhost:5000/jogadores/medias/$posicaoFavorita"))
            .timeout(const Duration(seconds: 5));

        if (response2.statusCode == 200) {
          var body2 = jsonDecode(response2.body);
          mediaGeral = Estatisticas.fromJsonAll(body2);
        }
      }
    } catch (e) {
      debugPrint("getInfo: $e");
    }
  }

  Future<void> form(int idJogador, String form) async {
    try {
      var response = await http
          .get(Uri.parse("http://localhost:5000/jogadores/$idJogador/$form"))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        nota = body['nota'];
        estatisticas = Estatisticas.fromJsonAll(body['estatisticas']);
        partidasJogadas = body['partidas_jogadas'];
        destaques = [];
        for (var i in body['destaques']) {
          destaques.add(Destaque.fromJsonAll(i));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class Estatisticas {
  double? nota;
  int? impedimentosTotal;
  double? impedimentosAvg;
  int? chutesTotal;
  double? chutesAvg;
  int? chutesNoGolTotal;
  double? chutesNoGolAvg;
  int? golsTotal;
  double? golsAvg;
  int? golsSofridosTotal;
  double? golsSofridosAvg;
  int? assistenciasTotal;
  double? assistenciasAvg;
  int? defesasTotal;
  double? defesasAvg;
  int? passesTotal;
  double? passesAvg;
  int? passesChavesTotal;
  double? passesChavesAvg;
  int? passesCertosTotal;
  double? passesCertosAvg;
  int? desarmesTotal;
  double? desarmesAvg;
  int? bloqueadosTotal;
  double? bloqueadosAvg;
  int? interceptadosTotal;
  double? interceptadosAvg;
  int? duelosTotal;
  double? duelosAvg;
  int? duelosGanhosTotal;
  double? duelosGanhosAvg;
  int? driblesTentadosTotal;
  double? driblesTentadosAvg;
  int? driblesCompletosTotal;
  double? driblesCompletosAvg;
  int? jogadoresPassadosTotal;
  double? jogadoresPassadosAvg;
  int? faltasSofridasTotal;
  double? faltasSofridasAvg;
  int? faltasCometidasTotal;
  double? faltasCometidasAvg;
  int? cartoesAmarelosTotal;
  double? cartoesAmarelosAvg;
  int? cartoesVermelhosTotal;
  double? cartoesVermelhosAvg;
  int? penaltisCometidosTotal;
  double? penaltisCometidosAvg;

  Estatisticas();

  Estatisticas.fromJsonAll(Map<String, dynamic> json)
      : nota = json['nota'],
        impedimentosTotal = json['impedimentos_total'],
        impedimentosAvg = json['impedimentos_avg'],
        chutesTotal = json['chutes_total'],
        chutesAvg = json['chutes_avg'],
        chutesNoGolTotal = json['chutes_no_gol_total'],
        chutesNoGolAvg = json['chutes_no_gol_avg'],
        golsTotal = json['gols_total'],
        golsAvg = json['gols_avg'],
        golsSofridosTotal = json['gols_sofridos_total'],
        golsSofridosAvg = json['gols_sofridos_avg'],
        assistenciasTotal = json['assistencias_total'],
        assistenciasAvg = json['assistencias_avg'],
        defesasTotal = json['defesas_total'],
        defesasAvg = json['defesas_avg'],
        passesTotal = json['passes_total'],
        passesAvg = json['passes_avg'],
        passesChavesTotal = json['passes_chaves_total'],
        passesChavesAvg = json['passes_chaves_avg'],
        passesCertosTotal = json['passes_certos_total'],
        passesCertosAvg = json['passes_certos_avg'],
        desarmesTotal = json['desarmes_total'],
        desarmesAvg = json['desarmes_avg'],
        bloqueadosTotal = json['bloqueados_total'],
        bloqueadosAvg = json['bloqueados_avg'],
        interceptadosTotal = json['interceptados_total'],
        interceptadosAvg = json['interceptados_avg'],
        duelosTotal = json['duelos_total'],
        duelosAvg = json['duelos_avg'],
        duelosGanhosTotal = json['duelos_ganhos_total'],
        duelosGanhosAvg = json['duelos_ganhos_avg'],
        driblesTentadosTotal = json['dribles_tentados_total'],
        driblesTentadosAvg = json['dribles_tentados_avg'],
        driblesCompletosTotal = json['dribles_completos_total'],
        driblesCompletosAvg = json['dribles_completos_avg'],
        jogadoresPassadosTotal = json['jogadores_passados_total'],
        jogadoresPassadosAvg = json['jogadores_passados_avg'],
        faltasSofridasTotal = json['faltas_sofridas_total'],
        faltasSofridasAvg = json['faltas_sofridas_avg'],
        faltasCometidasTotal = json['faltas_cometidas_total'],
        faltasCometidasAvg = json['faltas_cometidas_avg'],
        cartoesAmarelosTotal = json['cartoes_amarelos_total'],
        cartoesAmarelosAvg = json['cartoes_amarelos_avg'],
        cartoesVermelhosTotal = json['cartoes_vermelhos_total'],
        cartoesVermelhosAvg = json['cartoes_vermelhos_avg'],
        penaltisCometidosTotal = json['penaltis_cometidos_total'],
        penaltisCometidosAvg = json['penaltis_cometidos_avg'];

  Map<String, dynamic> toJson() {
    return {
      'impedimentosAvg': impedimentosAvg,
      'chutesAvg': chutesAvg,
      'chutesNoGolAvg': chutesNoGolAvg,
      'golsAvg': golsAvg,
      'golsSofridosAvg': golsSofridosAvg,
      'assistenciasAvg': assistenciasAvg,
      'defesasAvg': defesasAvg,
      'passesAvg': passesAvg,
      'passesChavesAvg': passesChavesAvg,
      'passesCertosAvg': passesCertosAvg,
      'desarmesAvg': desarmesAvg,
      'bloqueadosAvg': bloqueadosAvg,
      'interceptadosAvg': interceptadosAvg,
      'duelosAvg': duelosAvg,
      'duelosGanhosAvg': duelosGanhosAvg,
      'driblesTentadosAvg': driblesTentadosAvg,
      'driblesCompletosAvg': driblesCompletosAvg,
      'jogadoresPassadosAvg': jogadoresPassadosAvg,
      'faltasSofridasAvg': faltasSofridasAvg,
      'faltasCometidasAvg': faltasCometidasAvg,
      'cartoesAmarelosAvg': cartoesAmarelosAvg,
      'cartoesVermelhosAvg': cartoesVermelhosAvg,
      'penaltisCometidosAvg': penaltisCometidosAvg,
    };
  }
}

class Destaque {
  String? logoTimeMandante;
  String? logoTimeVisitante;
  double? nota;

  Destaque.fromJsonAll(Map<String, dynamic> json)
      : logoTimeMandante = json['logo_mandante'],
        logoTimeVisitante = json['logo_visitante'],
        nota = json['nota'];
}
