import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scout/util/util.dart';

class IaMobile extends StatefulWidget {
  final String? mandante;
  final String? visitante;
  const IaMobile({super.key, this.mandante, this.visitante});

  @override
  State<StatefulWidget> createState() => _IaMobileState();
}

class _IaMobileState extends State<IaMobile> {
  bool carregando = false;
  IaRepository iaRepository = IaRepository();
  String resultado = "Sua previsão aqui";
  String? timeMandante = "Mandante";
  String? formacaoMandante = "Formação";
  String? timeVisitante = "Visitante";
  String? formacaoVisitante = "Formação";
  String? clima = "Clima";
  String? horario = "Horário";

  final List<String> opcoesTime = [
    "Selecione",
    "Corinthians",
    "Palmeiras",
    "São Paulo",
    "Santos"
  ];

  final timeDic = {
    "Bahia": "https://media.api-sports.io/football/teams/118.png",
    "Internacional": "https://media.api-sports.io/football/teams/119.png",
    "Botafogo": "https://media.api-sports.io/football/teams/120.png",
    "Palmeiras": "https://media.api-sports.io/football/teams/121.png",
    "Fluminense": "https://media.api-sports.io/football/teams/124.png",
    "Sao Paulo": "https://media.api-sports.io/football/teams/126.png",
    "Flamengo": "https://media.api-sports.io/football/teams/127.png",
    "Santos": "https://media.api-sports.io/football/teams/128.png",
    "Gremio": "https://media.api-sports.io/football/teams/130.png",
    "Corinthians": "https://media.api-sports.io/football/teams/131.png",
    "Vasco DA Gama": "https://media.api-sports.io/football/teams/133.png",
    "Atletico Paranaense": "https://media.api-sports.io/football/teams/134.png",
    "Cruzeiro": "https://media.api-sports.io/football/teams/135.png",
    "Vitoria": "https://media.api-sports.io/football/teams/136.png",
    "Criciuma": "https://media.api-sports.io/football/teams/140.png",
    "Atletico Goianiense": "https://media.api-sports.io/football/teams/144.png",
    "Juventude": "https://media.api-sports.io/football/teams/152.png",
    "Fortaleza EC": "https://media.api-sports.io/football/teams/154.png",
    "RB Bragantino": "https://media.api-sports.io/football/teams/794.png",
    "Atletico-MG": "https://media.api-sports.io/football/teams/1062.png",
    "Cuiaba": "https://media.api-sports.io/football/teams/1193.png",
  };

  final opcoesFormacao = [
    "Formação",
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

  final List<String> opcoesHorario = ["Horário", "Dia", "Noite"];
  final List<String> opcoesClima = ["Clima", "Ceu limpo", "Chuva", "Nublado"];

  Future<void> request() async {
    if (timeMandante == null ||
        timeMandante == "Mandante" ||
        timeVisitante == null ||
        timeVisitante == "Visitante" ||
        formacaoMandante == null ||
        formacaoMandante == "Formação" ||
        formacaoVisitante == null ||
        formacaoVisitante == "Formação" ||
        horario == null ||
        horario == "Horário" ||
        clima == null ||
        clima == "Clima") {
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

    timeMandante = widget.mandante ?? "Mandante";
    timeVisitante = widget.visitante ?? "Visitante";
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
                  fontSize: fatorDeEscalaMobile(35, context)),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: fatorDeEscalaMobile(50, context),
                      vertical: fatorDeEscalaMobile(10, context)),
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
                                            fatorDeEscalaMobile(10, context)),
                                    child: Row(children: [
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
                                          items: [
                                            for (var i in [
                                              "Mandante",
                                              ...timeDic.keys
                                            ])
                                              DropdownMenuItem(
                                                  value: i,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            fatorDeEscalaMobile(
                                                                8.0, context)),
                                                    child: Text(i,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  )),
                                          ],
                                          onChanged: (value) {
                                            if (value != "Mandante" &&
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
                                            fatorDeEscalaMobile(10, context)),
                                    child: Row(children: [
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
                                          value: formacaoMandante,
                                          items: [
                                            for (var i in opcoesFormacao)
                                              DropdownMenuItem(
                                                  value: i,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            fatorDeEscalaMobile(
                                                                8.0, context)),
                                                    child: Text(i,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
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
                                      timeMandante != "Mandante") {
                                    return Image.network(
                                      timeDic[timeMandante]!,
                                      scale:
                                          fatorDeEscalaMenorReverso(2, context),
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
                                            fatorDeEscalaMobile(10, context)),
                                    child: Row(children: [
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
                                          items: [
                                            for (var i in [
                                              "Visitante",
                                              ...timeDic.keys
                                            ])
                                              DropdownMenuItem(
                                                  value: i,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: Text(i,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  )),
                                          ],
                                          onChanged: (value) {
                                            if (value != "Visitante" &&
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
                                            fatorDeEscalaMobile(10, context)),
                                    child: Row(children: [
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
                                          items: [
                                            for (var i in opcoesFormacao)
                                              DropdownMenuItem(
                                                  value: i,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: Text(i,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
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
                                      timeVisitante != "Visitante") {
                                    return Image.network(
                                      timeDic[timeVisitante]!,
                                      scale:
                                          fatorDeEscalaMenorReverso(2, context),
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
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: fatorDeEscalaMobile(20, context)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    //seleção clima
                                    Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              68, 34, 197, 94),
                                          border:
                                              Border.all(color: Colors.green),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                        dropdownColor: Colors.green,
                                        value: clima,
                                        items: [
                                          for (var i in opcoesClima)
                                            DropdownMenuItem(
                                                value: i,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(i,
                                                      style: const TextStyle(
                                                          color: Colors.white)),
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
                                          border:
                                              Border.all(color: Colors.green),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                        dropdownColor: Colors.green,
                                        value: horario,
                                        items: [
                                          for (var i in opcoesHorario)
                                            DropdownMenuItem(
                                                value: i,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(i,
                                                      style: const TextStyle(
                                                          color: Colors.white)),
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
                            ),
                            //Botão prever resultado
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: fatorDeEscalaMobile(20, context)),
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
                                            fontSize: fatorDeEscalaMobile(
                                                30, context)),
                                      ))
                                ],
                              ),
                            )
                          ],
                        )
                      ]),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: fatorDeEscalaMobile(50, context),
                      vertical: fatorDeEscalaMobile(10, context)),
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
                                  fontSize: fatorDeEscalaMobile(50, context)),
                            ),
                            Builder(
                              builder: (context) {
                                if (iaRepository.chanceMandante >
                                    iaRepository.chanceVisitante) {
                                  return Column(
                                    children: [
                                      Text(
                                        "Vítoria do ${timeMandante ?? "Mandante"}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMobile(
                                                30, context)),
                                      ),
                                      Image.network(
                                        timeDic[iaRepository.mandante]!,
                                        scale: fatorDeEscalaMenorReverso(
                                            4, context),
                                      ),
                                    ],
                                  );
                                } else if (iaRepository.chanceVisitante >
                                    iaRepository.chanceMandante) {
                                  return Column(
                                    children: [
                                      Text(
                                        "Vítoria do ${timeMandante ?? "Visitante"}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMobile(
                                                30, context)),
                                      ),
                                      Image.network(
                                        timeDic[iaRepository.visitante]!,
                                        scale: fatorDeEscalaMenorReverso(
                                            4, context),
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
                                            fontSize: fatorDeEscalaMobile(
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
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: fatorDeEscalaMobile(20, context)),
                            child: Column(
                              children: [
                                Text(
                                  "Probabilidades",
                                  style: TextStyle(
                                      color: Colors.green.shade400,
                                      fontSize:
                                          fatorDeEscalaMobile(40, context)),
                                ),
                                Text(
                                  "Empate: ${(iaRepository.chanceEmpate * 100).toStringAsFixed(2)}%",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMobile(20, context)),
                                ),
                                Text(
                                  "Vitória Mandante: ${(iaRepository.chanceMandante * 100).toStringAsFixed(2)}%",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMobile(20, context)),
                                ),
                                Text(
                                  "Vitória Visitante: ${(iaRepository.chanceVisitante * 100).toStringAsFixed(2)}%",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMobile(20, context)),
                                )
                              ],
                            ),
                          )
                        ]);
                  }),
                )
              ],
            ),
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
        Uri.parse("http://localhost:5000/ia/"),
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

/*


                        
                        */