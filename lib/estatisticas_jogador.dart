import 'package:flutter/material.dart';
import 'package:scout/repository/jogador_repository.dart';

class JogadorEstatisticas extends StatefulWidget {
  final int idJogador;
  const JogadorEstatisticas({super.key, required this.idJogador});

  @override
  State<StatefulWidget> createState() => _JogadorEstatisticaState();
}

class _JogadorEstatisticaState extends State<JogadorEstatisticas> {
  JogadorRepository jogadorRepository = JogadorRepository();
  bool carregando = false;
  bool geral = true;
  bool valorSwitch = true;
  TextEditingController controller = TextEditingController();
  ScrollController controllerSCS = ScrollController();

  @override
  void initState() {
    super.initState();
    awaits();
  }

  Future<void> awaits() async {
    setState(() {
      carregando = true;
      geral = true;
    });
    await jogadorRepository.getInfo(widget.idJogador);

    setState(() {
      controller.value = const TextEditingValue(text: "Geral");
      jogadorRepository = jogadorRepository;
      carregando = false;
    });
  }

  Future<void> awaits2(String form) async {
    setState(() {
      carregando = true;
      geral = false;
    });
    await jogadorRepository.form(widget.idJogador, form);

    setState(() {
      jogadorRepository = jogadorRepository;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(158, 134, 132, 131),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.all(50),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: jogadorRepository.jogador.image == null
                      ? null
                      : NetworkImage(jogadorRepository.jogador.image!),
                  radius: 150,
                ),
                Text(
                  jogadorRepository.jogador.nome ?? "Carregando...",
                  style: const TextStyle(fontSize: 35),
                ),
                Text(
                  jogadorRepository.nomeTime ?? "Carregando...",
                  style: const TextStyle(fontSize: 20),
                ),
                DropdownMenu(
                  controller: controller,
                  hintText: "Formacão",
                  onSelected: (value) {
                    if (value != "Geral") {
                      awaits2(value!);
                    } else {
                      awaits();
                    }
                  },
                  requestFocusOnTap: false,
                  dropdownMenuEntries: [
                    const DropdownMenuEntry(value: "Geral", label: "Geral"),
                    for (String i in jogadorRepository.formacoes)
                      DropdownMenuEntry(value: i, label: i),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: !carregando
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            containerNota(
                                jogadorRepository.estatisticas?.nota ?? 0),
                            Container(
                              margin: const EdgeInsets.all(25),
                              child: Builder(
                                builder: (context) {
                                  List<Widget> estatisticas = [];
                                  String? posicaoFavorita =
                                      jogadorRepository.posicaoFavorita;

                                  if (posicaoFavorita == 'G') {
                                    estatisticas.add(Text(
                                        "Defesas: ${jogadorRepository.estatisticas?.defesasTotal ?? 0}"));
                                    estatisticas.add(Text(
                                        "Gols sofridos: ${jogadorRepository.estatisticas?.golsSofridosTotal ?? 0}"));
                                  } else if (posicaoFavorita == 'D') {
                                    estatisticas.add(Text(
                                        "Duelos ganhos: ${jogadorRepository.estatisticas?.duelosGanhosTotal ?? 0}"));
                                    estatisticas.add(Text(
                                        "Bloqueios: ${jogadorRepository.estatisticas?.bloqueadosTotal ?? 0}"));
                                    estatisticas.add(Text(
                                        "Interceptação: ${jogadorRepository.estatisticas?.interceptadosTotal ?? 0}"));
                                  } else if (posicaoFavorita == 'M') {
                                    estatisticas.add(Text(
                                        "Passes certos: ${jogadorRepository.estatisticas?.passesCertosTotal ?? 0}"));
                                    estatisticas.add(Text(
                                        "Grandes chances criadas: ${jogadorRepository.estatisticas?.passesChavesTotal ?? 0}"));
                                    estatisticas.add(Text(
                                        "Dribles completos: ${jogadorRepository.estatisticas?.driblesCompletosTotal ?? 0}"));
                                  } else {
                                    estatisticas.add(Text(
                                        "Gols: ${jogadorRepository.estatisticas?.duelosGanhosTotal ?? 0}"));
                                    estatisticas.add(Text(
                                        "Chutes no gol: ${jogadorRepository.estatisticas?.chutesNoGolTotal ?? 0}"));
                                    estatisticas.add(Text(
                                        "Assistencias: ${jogadorRepository.estatisticas?.assistenciasTotal ?? 0}"));
                                  }

                                  return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (Widget i in estatisticas) i,
                                        Text(
                                            "Partidas jogadas: ${jogadorRepository.partidasJogadas ?? 0}"),
                                      ]);
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Destaques:"),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(),
                                  for (Destaque i
                                      in jogadorRepository.destaques)
                                    destaque(i),
                                  Container(),
                                ]),
                          ],
                        ),
                        if (geral) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(),
                              containerAtributos(
                                  jogadorRepository.estatisticasFormFav ??
                                      Estatisticas(),
                                  jogadorRepository.formacaoFavorita,
                                  null),
                              containerAtributos(
                                  jogadorRepository.estatisticasPosFav ??
                                      Estatisticas(),
                                  null,
                                  jogadorRepository.posicaoFavorita),
                              Container(),
                            ],
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Text("Na ${controller.text}:"),
                              Switch(
                                trackColor: valorSwitch
                                    ? const MaterialStatePropertyAll(
                                        Colors.green)
                                    : const MaterialStatePropertyAll(
                                        Colors.red),
                                value: valorSwitch,
                                onChanged: (value) {
                                  setState(() {
                                    valorSwitch = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Builder(
                            builder: (context) {
                              if (valorSwitch) {
                                List<Widget> pontos = grandeComparacao(
                                    jogadorRepository.estatisticas,
                                    jogadorRepository.mediaGeral,
                                    jogadorRepository.posicaoFavorita,
                                    valorSwitch);

                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Colors.white,
                                      height: 300,
                                      child: SingleChildScrollView(
                                        controller: controllerSCS,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (Widget i in pontos) i
                                          ],
                                        ),
                                      ),
                                    ));
                              } else {
                                List<Widget> pontos = grandeComparacao(
                                    jogadorRepository.estatisticas,
                                    jogadorRepository.mediaGeral,
                                    jogadorRepository.posicaoFavorita,
                                    valorSwitch);
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Colors.white,
                                      height: 300,
                                      child: SingleChildScrollView(
                                        controller: controllerSCS,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (Widget i in pontos) i
                                          ],
                                        ),
                                      ),
                                    ));
                              }
                            },
                          ),
                          Container(),
                        ]
                      ])
                : const Center(child: CircularProgressIndicator()),
          ),
        )
      ]),
    );
  }

  MaterialColor corNota(double nota) {
    if (nota >= 7) {
      return Colors.green;
    } else if (nota > 6.5) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  Widget destaque(Destaque destaque) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: corNota(destaque.nota ?? 0),
        height: 50,
        width: 150,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(destaque.nota.toString()),
          Image.network(destaque.logoTimeMandante!),
          Image.network(destaque.logoTimeVisitante!)
        ]),
      ),
    );
  }

  Widget containerNota(double nota) {
    Widget x = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        color: corNota(nota),
        child: Text(nota.toStringAsFixed(2)),
      ),
    );

    return x;
  }

  Widget containerAtributos(Estatisticas estatisticas, String? formacaoFavorita,
      String? posicaoFavorita) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 200,
        height: 125,
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (formacaoFavorita != null) ...[
            Text("Formação favorita: $formacaoFavorita"),
          ] else ...[
            Text("Posição favorita: $posicaoFavorita"),
          ],
          Text("Nota: ${estatisticas.nota?.toStringAsFixed(2) ?? 0}"),
          Text("Passes certos: ${estatisticas.passesCertosTotal ?? 0}"),
          Text("Assistencias: ${estatisticas.assistenciasTotal ?? 0}"),
          Text("Dribles completos: ${estatisticas.driblesCompletosTotal ?? 0}"),
        ]),
      ),
    );
  }

  List<Widget> grandeComparacao(Estatisticas? jogador, Estatisticas? mediaGeral,
      String? posicaofav, bool positivo) {
    List<Widget> lista = [];

    final atributosPositivos = {
      'chutesAvg': "chutes",
      'chutesNoGolAvg': "chutes no gol",
      'golsAvg': "gols",
      'assistenciasAvg': "assistências",
      'defesasAvg': "defesas",
      'passesAvg': "passes",
      'passesChavesAvg': "passes chave",
      'passesCertosAvg': "passes certos",
      'desarmesAvg': "desarmes",
      'bloqueadosAvg': "bloqueios",
      'interceptadosAvg': "interceptações",
      'duelosAvg': "duelos",
      'duelosGanhosAvg': "duelos ganhos",
      'driblesTentadosAvg': "dribles tentados",
      'driblesCompletosAvg': "dribles completos",
      'jogadoresPassadosAvg': "jogadores passados",
      'faltasSofridasAvg': "faltas sofridas",
    };

    final atributosNegativos = {
      'impedimentosAvg': "impedimentos",
      'faltasCometidasAvg': "faltas cometidas",
      'cartoesAmarelosAvg': "cartões amarelos",
      'cartoesVermelhosAvg': "cartões vermelhos",
      'penaltisCometidosAvg': "penaltis cometidos"
    };

    final posicoes = {
      "G": "goleiros",
      "D": "defensores",
      "M": "meias",
      "F": "atacantes",
    };

    if (positivo) {
      atributosPositivos.forEach((key, value) {
        double jogadorValue = jogador?.toJson()[key] ?? 0.0;
        double mediaValue = mediaGeral?.toJson()[key] ?? 0.0;

        if (jogadorValue > mediaValue) {
          lista.add(Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text:
                      "O jogador tem média $value acima da média geral de ${posicoes[posicaofav]} da série A. "),
              TextSpan(
                  text: jogadorValue.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.green)),
              const TextSpan(text: "/partida!"),
            ])),
          ));
        }
      });
      atributosNegativos.forEach((key, value) {
        double jogadorValue = jogador?.toJson()[key] ?? 0.0;
        double mediaValue = mediaGeral?.toJson()[key] ?? 0.0;

        if (jogadorValue < mediaValue) {
          lista.add(Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text:
                      "O jogador tem média $value abaixo da média geral de ${posicoes[posicaofav]} da série A. "),
              TextSpan(
                  text: jogadorValue.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.green)),
              const TextSpan(text: "/partida."),
            ])),
          ));
        }
      });
    } else {
      atributosPositivos.forEach((key, value) {
        double jogadorValue = jogador?.toJson()[key] ?? 0.0;
        double mediaValue = mediaGeral?.toJson()[key] ?? 0.0;

        if (jogadorValue < mediaValue) {
          lista.add(Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text:
                      "O jogador tem média $value abaixo da média geral de ${posicoes[posicaofav]} da série A. "),
              TextSpan(
                  text: jogadorValue.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.red)),
              const TextSpan(text: "/partida!"),
            ])),
          ));
        }
      });
      atributosNegativos.forEach((key, value) {
        double jogadorValue = jogador?.toJson()[key] ?? 0.0;
        double mediaValue = mediaGeral?.toJson()[key] ?? 0.0;

        if (jogadorValue > mediaValue) {
          lista.add(Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text:
                      "O jogador tem média $value acima da média geral de ${posicoes[posicaofav]} da série A. "),
              TextSpan(
                  text: jogadorValue.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.red)),
              const TextSpan(text: "/partida."),
            ])),
          ));
        }
      });
    }
    return lista;
  }
}
