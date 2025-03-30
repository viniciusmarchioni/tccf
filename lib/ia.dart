import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ia extends StatefulWidget {
  const Ia({super.key});

  @override
  State<StatefulWidget> createState() => _IaState();
}

class _IaState extends State<Ia> {
  bool carregando = false;
  IaRepository iaRepository = IaRepository();
  TextEditingController controllerMandante = TextEditingController();
  TextEditingController controllerVisitante = TextEditingController();
  TextEditingController controllerFormMandante = TextEditingController();
  TextEditingController controllerFormVisitante = TextEditingController();
  TextEditingController controllerHorario = TextEditingController();
  TextEditingController controllerClima = TextEditingController();

  String resultado = "Sua previsão aqui";

  final List<String> opcoesTime = [
    "Corinthians",
    "Palmeiras",
    "São Paulo",
    "Santos"
  ];

  final List<String> opcoesFormacao = ["4-3-1-2", "4-3-3", "3-5-2", "4-4-2"];

  final List<String> opcoesHorario = ["Dia", "Noite"];
  final List<String> opcoesClima = ["Ceu limpo", "Chuva", "Nublado"];

  Future<void> request() async {
    setState(() {
      carregando = true;
    });
    iaRepository.mandante = controllerMandante.text;
    iaRepository.visitante = controllerVisitante.text;
    iaRepository.formMandante = controllerFormMandante.text;
    iaRepository.formVisitante = controllerFormVisitante.text;
    iaRepository.horario = controllerHorario.text;
    iaRepository.clima = controllerClima.text;
    await iaRepository.pesquisa();

    setState(() {
      iaRepository = iaRepository;
      resultado =
          "Empate: ${iaRepository.chanceEmpate * 100}\n Mandante:${iaRepository.chanceMandante * 100}\n Visitante:${iaRepository.chanceVisitante * 100}";
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (carregando) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                    children: [
                      DropdownMenu(
                          controller: controllerMandante,
                          dropdownMenuEntries: [
                            for (String i in opcoesTime)
                              DropdownMenuEntry(value: i, label: i)
                          ]),
                      DropdownMenu(
                          controller: controllerFormMandante,
                          dropdownMenuEntries: [
                            for (String i in opcoesFormacao)
                              DropdownMenuEntry(value: i, label: i)
                          ]),
                    ],
                  ),
                  Column(
                    children: [
                      DropdownMenu(
                          controller: controllerVisitante,
                          dropdownMenuEntries: [
                            for (String i in opcoesTime)
                              DropdownMenuEntry(value: i, label: i)
                          ]),
                      DropdownMenu(
                          controller: controllerFormVisitante,
                          dropdownMenuEntries: [
                            for (String i in opcoesFormacao)
                              DropdownMenuEntry(value: i, label: i)
                          ]),
                    ],
                  )
                ]),
                DropdownMenu(
                    controller: controllerHorario,
                    dropdownMenuEntries: [
                      for (String i in opcoesHorario)
                        DropdownMenuEntry(value: i, label: i)
                    ]),
                DropdownMenu(controller: controllerClima, dropdownMenuEntries: [
                  for (String i in opcoesClima)
                    DropdownMenuEntry(value: i, label: i)
                ]),
                ElevatedButton(
                    onPressed: () {
                      request();
                    },
                    child: const Text("Gerar previsão")),
                Text(resultado)
              ],
            ),
          );
        }
      },
    );
  }
}

class IaRepository {
  String mandante = "";
  String visitante = "";
  String formMandante = "";
  String formVisitante = "";
  String horario = "";
  String clima = "";
  double chanceEmpate = 0;
  double chanceMandante = 0;
  double chanceVisitante = 0;

  IaRepository();

  Future<void> pesquisa() async {
    try {
      final response = await http.post(
        Uri.parse("https://corinthianspaulista1910.duckdns.org/ia/"),
        body: jsonEncode({
          "time_mandante": mandante,
          "time_visitante": visitante,
          "formacao_mandante": formMandante,
          "formacao_visitante": formVisitante,
          "condicao": clima,
          "momento_dia": horario
        }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        chanceEmpate = body['empate'];
        chanceMandante = body['mandante'];
        chanceVisitante = body['visitante'];
      } else {
        debugPrint(response.statusCode.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
