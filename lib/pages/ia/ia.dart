import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scout/util/util.dart';

class Ia extends StatefulWidget {
  final String? mandante;
  final String? visitante;
  const Ia({super.key, this.mandante, this.visitante});

  @override
  State<StatefulWidget> createState() => _IaState();
}

class _IaState extends State<Ia> {
  bool carregando = false;
  IaRepository iaRepository = IaRepository();
  String resultado = "Sua previsão aqui";
  String? timeMandante = "Selecione";
  String? formacaoMandante = "Selecione";
  String? timeVisitante = "Selecione";
  String? formacaoVisitante = "Selecione";
  String? clima = "Selecione";
  String? horario = "Selecione";

  final timeDic = {
    "Bahia": "https://media.api-sports.io/football/teams/118.png",
    "Internacional": "https://media.api-sports.io/football/teams/119.png",
    "Botafogo": "https://media.api-sports.io/football/teams/120.png",
    "Palmeiras": "https://media.api-sports.io/football/teams/121.png",
    "Sport Recife": "https://media.api-sports.io/football/teams/123.png",
    "Fluminense": "https://media.api-sports.io/football/teams/124.png",
    "Sao Paulo": "https://media.api-sports.io/football/teams/126.png",
    "Flamengo": "https://media.api-sports.io/football/teams/127.png",
    "Santos": "https://media.api-sports.io/football/teams/128.png",
    "Ceara": "https://media.api-sports.io/football/teams/129.png",
    "Gremio": "https://media.api-sports.io/football/teams/130.png",
    "Corinthians": "https://media.api-sports.io/football/teams/131.png",
    "Vasco DA Gama": "https://media.api-sports.io/football/teams/133.png",
    "Cruzeiro": "https://media.api-sports.io/football/teams/135.png",
    "Vitoria": "https://media.api-sports.io/football/teams/136.png",
    "Juventude": "https://media.api-sports.io/football/teams/152.png",
    "Fortaleza EC": "https://media.api-sports.io/football/teams/154.png",
    "RB Bragantino": "https://media.api-sports.io/football/teams/794.png",
    "Atletico-MG": "https://media.api-sports.io/football/teams/1062.png",
    "Mirassol": "https://media.api-sports.io/football/teams/7848.png",
  };

  final opcoesFormacao = [
    "Selecione",
    "4-4-2",
    "4-3-3",
    "4-2-3-1",
    "3-4-1-2",
    "4-3-1-2",
    "4-1-3-2",
    "3-4-2-1",
    "3-5-2",
    "4-4-1-1",
    "5-4-1",
    "3-4-3",
    "4-3-2-1",
    "4-1-4-1",
    "5-3-2",
    "4-2-2-2",
    "4-5-1",
    "3-3-3-1",
    "3-3-1-3",
    "3-5-1-1",
    "3-2-4-1",
    "3-1-4-2",
  ];

  final List<String> opcoesHorario = ["Selecione", "Dia", "Noite"];
  final List<String> opcoesClima = [
    "Selecione",
    "Ceu limpo",
    "Chuva",
    "Nublado"
  ];

  Future<void> request() async {
    if (timeMandante == null ||
        timeMandante == "Selecione" ||
        timeVisitante == null ||
        timeVisitante == "Selecione" ||
        formacaoMandante == null ||
        formacaoMandante == "Selecione" ||
        formacaoVisitante == null ||
        formacaoVisitante == "Selecione" ||
        horario == null ||
        horario == "Selecione" ||
        clima == null ||
        clima == "Selecione") {
      return;
    }

    setState(() {
      carregando = true;
    });

    iaRepository.mandante = timeMandante!;
    iaRepository.visitante = timeVisitante!;
    iaRepository.formMandante = formacaoMandante!;
    iaRepository.formVisitante = formacaoVisitante!;
    iaRepository.clima = clima!;
    iaRepository.horario = horario!;

    await iaRepository.pesquisa();

    setState(() {
      iaRepository = iaRepository;
      carregando = false;
    });
  }

  @override
  void initState() {
    super.initState();

    timeMandante = widget.mandante ?? "Selecione";
    timeVisitante = widget.visitante ?? "Selecione";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Previsão da partida",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMenor(35, context)),
            ),
          ],
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(fatorDeEscalaMenor(50, context)),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(68, 34, 197, 94),
                      border: Border.all(color: Colors.green),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Seleção mandante
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            fatorDeEscalaMenor(10, context)),
                                    child: Row(children: [
                                      Text(
                                        "Mandante: ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMenor(
                                                30, context)),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                68, 34, 197, 94),
                                            border:
                                                Border.all(color: Colors.green),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                          menuMaxHeight: 300,
                                          dropdownColor: Colors.green,
                                          value: timeMandante,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fatorDeEscalaMenor(
                                                  25, context)),
                                          items: [
                                            for (var i in [
                                              "Selecione",
                                              ...timeDic.keys
                                            ])
                                              DropdownMenuItem(
                                                  value: i,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            fatorDeEscalaMenor(
                                                                8.0, context)),
                                                    child: Text(i),
                                                  )),
                                          ],
                                          onChanged: (value) {
                                            if (value != "Selecione" &&
                                                value == timeVisitante) {
                                              return;
                                            }
                                            setState(() {
                                              timeMandante = value;
                                            });
                                          },
                                        )),
                                      )
                                    ]),
                                  ),
                                  //Seleção formação mandante
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            fatorDeEscalaMenor(10, context)),
                                    child: Row(children: [
                                      Text(
                                        "Formação: ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMenor(
                                                30, context)),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                68, 34, 197, 94),
                                            border:
                                                Border.all(color: Colors.green),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                          menuMaxHeight: 300,
                                          dropdownColor: Colors.green,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fatorDeEscalaMenor(
                                                  25, context)),
                                          value: formacaoMandante,
                                          items: [
                                            for (var i in opcoesFormacao)
                                              DropdownMenuItem(
                                                  value: i,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            fatorDeEscalaMenor(
                                                                8.0, context)),
                                                    child: Text(i),
                                                  )),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              formacaoMandante = value;
                                            });
                                          },
                                        )),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                              Builder(
                                builder: (context) {
                                  if (timeMandante != null &&
                                      timeMandante != "Selecione") {
                                    return Image.network(
                                      timeDic[timeMandante]!,
                                      scale:
                                          fatorDeEscalaMenorReverso(1, context),
                                    );
                                  }
                                  return Container();
                                },
                              )
                            ]),
                        const Divider(
                          color: Colors.green,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Seleção visitante
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            fatorDeEscalaMenor(10, context)),
                                    child: Row(children: [
                                      Text(
                                        "Visitante:   ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMenor(
                                                30, context)),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                68, 34, 197, 94),
                                            border:
                                                Border.all(color: Colors.green),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                          menuMaxHeight: 300,
                                          dropdownColor: Colors.green,
                                          value: timeVisitante,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fatorDeEscalaMenor(
                                                  25, context)),
                                          items: [
                                            for (var i in [
                                              "Selecione",
                                              ...timeDic.keys
                                            ])
                                              DropdownMenuItem(
                                                  value: i,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: Text(i),
                                                  )),
                                          ],
                                          onChanged: (value) {
                                            if (value != "Selecione" &&
                                                value == timeMandante) {
                                              return;
                                            }
                                            setState(() {
                                              timeVisitante = value;
                                            });
                                          },
                                        )),
                                      )
                                    ]),
                                  ),
                                  //Seleção formação visitante
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            fatorDeEscalaMenor(10, context)),
                                    child: Row(children: [
                                      Text(
                                        "Formação: ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMenor(
                                                30, context)),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                68, 34, 197, 94),
                                            border:
                                                Border.all(color: Colors.green),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                          menuMaxHeight: 300,
                                          dropdownColor: Colors.green,
                                          value: formacaoVisitante,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fatorDeEscalaMenor(
                                                  25, context)),
                                          items: [
                                            for (var i in opcoesFormacao)
                                              DropdownMenuItem(
                                                  value: i,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: Text(i),
                                                  )),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              formacaoVisitante = value;
                                            });
                                          },
                                        )),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                              Builder(
                                builder: (context) {
                                  if (timeVisitante != null &&
                                      timeVisitante != "Selecione") {
                                    return Image.network(
                                      timeDic[timeVisitante]!,
                                      scale:
                                          fatorDeEscalaMenorReverso(1, context),
                                    );
                                  }
                                  return Container();
                                },
                              )
                            ]),
                        const Divider(
                          color: Colors.green,
                        ),
                        Column(
                          children: [
                            //Seleção clima
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //seleção clima
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            68, 34, 197, 94),
                                        border: Border.all(color: Colors.green),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                      value: clima,
                                      dropdownColor: Colors.green,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              fatorDeEscalaMenor(25, context)),
                                      items: [
                                        for (var i in opcoesClima)
                                          DropdownMenuItem(
                                              value: i,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(i),
                                              )),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          clima = value;
                                        });
                                      },
                                    )),
                                  ),
                                  //Selecao horário
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            68, 34, 197, 94),
                                        border: Border.all(color: Colors.green),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                      value: horario,
                                      dropdownColor: Colors.green,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              fatorDeEscalaMenor(25, context)),
                                      items: [
                                        for (var i in opcoesHorario)
                                          DropdownMenuItem(
                                              value: i,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(i),
                                              )),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          horario = value;
                                        });
                                      },
                                    )),
                                  )
                                ]),
                            //Botão prever resultado
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: fatorDeEscalaMenor(25, context)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.green)),
                                      onPressed: () {
                                        request();
                                      },
                                      child: Text(
                                        "Prever resultado",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMenor(
                                                30, context)),
                                      ))
                                ],
                              ),
                            )
                          ],
                        )
                      ]),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(fatorDeEscalaMenor(50, context)),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(68, 34, 197, 94),
                      border: Border.all(color: Colors.green),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Builder(builder: (context) {
                    if (carregando) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.green,
                      ));
                    }
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            Text(
                              "Resultado",
                              style: TextStyle(
                                  color: Colors.green.shade400,
                                  fontSize: fatorDeEscalaMenor(50, context)),
                            ),
                            Builder(
                              builder: (context) {
                                if (iaRepository.chanceMandante >
                                        iaRepository.chanceVisitante &&
                                    iaRepository.chanceMandante >
                                        iaRepository.chanceEmpate) {
                                  return Column(
                                    children: [
                                      Text(
                                        "Vitória Mandante",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMenor(
                                                30, context)),
                                      ),
                                      Image.network(
                                        timeDic[iaRepository.mandante]!,
                                        scale: fatorDeEscalaMenorReverso(
                                            1, context),
                                      ),
                                    ],
                                  );
                                } else if (iaRepository.chanceVisitante >
                                        iaRepository.chanceMandante &&
                                    iaRepository.chanceVisitante >
                                        iaRepository.chanceEmpate) {
                                  return Column(
                                    children: [
                                      Text(
                                        "Vitória Visitante",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMenor(
                                                30, context)),
                                      ),
                                      Image.network(
                                        timeDic[iaRepository.visitante]!,
                                        scale: fatorDeEscalaMenorReverso(
                                            1, context),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Text(
                                        "Empate",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMenor(
                                                30, context)),
                                      ),
                                    ],
                                  );
                                }
                              },
                            )
                          ]),
                          const Divider(
                            color: Colors.green,
                          ),
                          Column(
                            children: [
                              Text(
                                "Probabilidades",
                                style: TextStyle(
                                    color: Colors.green.shade400,
                                    fontSize: fatorDeEscalaMenor(40, context)),
                              ),
                              Text(
                                "Empate: ${(iaRepository.chanceEmpate * 100).toStringAsFixed(2)}%",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fatorDeEscalaMenor(20, context)),
                              ),
                              Text(
                                "Vitória Mandante: ${(iaRepository.chanceMandante * 100).toStringAsFixed(2)}%",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fatorDeEscalaMenor(20, context)),
                              ),
                              Text(
                                "Vitória Visitante: ${(iaRepository.chanceVisitante * 100).toStringAsFixed(2)}%",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fatorDeEscalaMenor(20, context)),
                              )
                            ],
                          )
                        ]);
                  }),
                ),
              )
            ],
          ),
        )
      ],
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
        Uri.parse("$endereco/ia/"),
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
        mandante = "";
        visitante = "";
        formMandante = "";
        formVisitante = "";
        horario = "";
        clima = "";
        chanceEmpate = 0;
        chanceMandante = 0;
        chanceVisitante = 0;
        debugPrint(response.statusCode.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
