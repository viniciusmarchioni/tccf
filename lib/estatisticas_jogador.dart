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
  String? dropDownValue = "Geral";
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
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2),
          color: const Color.fromARGB(255, 17, 34, 23),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
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
                  style: const TextStyle(fontSize: 35, color: Colors.white),
                ),
                Text(
                  jogadorRepository.nomeTime ?? "Carregando...",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.green)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.green,
                      value: dropDownValue,
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                      items: [
                        const DropdownMenuItem(
                            value: "Geral",
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("Geral"),
                            )),
                        for (String i in jogadorRepository.formacoes)
                          DropdownMenuItem(
                              value: i,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(i),
                              )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value != "Geral") {
                            dropDownValue = value;
                            awaits2(value);
                          } else {
                            dropDownValue = "Geral";
                            awaits();
                          }
                        });
                      },
                    ),
                  ),
                ),
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
                        Container(
                          margin: const EdgeInsets.all(25),
                          child: Builder(
                            builder: (context) {
                              List<Widget> estatisticas = [];
                              String? posicaoFavorita =
                                  jogadorRepository.posicaoFavorita;

                              if (posicaoFavorita == 'G') {
                                estatisticas.add(Text(
                                    "Defesas: ${jogadorRepository.estatisticas?.defesasTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                                estatisticas.add(Text(
                                    "Gols sofridos: ${jogadorRepository.estatisticas?.golsSofridosTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                              } else if (posicaoFavorita == 'D') {
                                estatisticas.add(Text(
                                    "Duelos ganhos: ${jogadorRepository.estatisticas?.duelosGanhosTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                                estatisticas.add(Text(
                                    "Bloqueios: ${jogadorRepository.estatisticas?.bloqueadosTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                                estatisticas.add(Text(
                                    "Interceptação: ${jogadorRepository.estatisticas?.interceptadosTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                              } else if (posicaoFavorita == 'M') {
                                estatisticas.add(Text(
                                    "Passes certos: ${jogadorRepository.estatisticas?.passesCertosTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                                estatisticas.add(Text(
                                    "Grandes chances criadas: ${jogadorRepository.estatisticas?.passesChavesTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                                estatisticas.add(Text(
                                    "Dribles completos: ${jogadorRepository.estatisticas?.driblesCompletosTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                              } else {
                                estatisticas.add(Text(
                                    "Gols: ${jogadorRepository.estatisticas?.golsTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                                estatisticas.add(Text(
                                    "Chutes no gol: ${jogadorRepository.estatisticas?.chutesNoGolTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                                estatisticas.add(Text(
                                    "Assistencias: ${jogadorRepository.estatisticas?.assistenciasTotal ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)));
                              }

                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (Widget i in estatisticas) i,
                                    Text(
                                        "Partidas jogadas: ${jogadorRepository.partidasJogadas ?? 0}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 25)),
                                  ]);
                            },
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Destaques:",
                                style: TextStyle(color: Colors.white)),
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
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                                color: valorSwitch
                                    ? const Color.fromARGB(68, 34, 197, 94)
                                    : const Color.fromARGB(100, 197, 34, 37),
                                border: Border.all(
                                    color:
                                        valorSwitch ? Colors.green : Colors.red,
                                    width: 2)),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.green)),
                                          onPressed: () {
                                            setState(() {
                                              valorSwitch = true;
                                            });
                                          },
                                          child: const Text(
                                            "Pontos positivos",
                                            style:
                                                TextStyle(color: Colors.green),
                                          )),
                                      OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.red)),
                                          onPressed: () {
                                            setState(() {
                                              valorSwitch = false;
                                            });
                                          },
                                          child: const Text(
                                            "Pontos negativos",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                    ]),
                                Expanded(
                                  child: SingleChildScrollView(
                                      child: Column(children: [
                                    for (var i in grandeComparacao(
                                        jogadorRepository.estatisticas,
                                        jogadorRepository.mediaGeral,
                                        jogadorRepository.posicaoFavorita,
                                        valorSwitch))
                                      i
                                  ])),
                                ),
                              ],
                            ),
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
    return Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
          color: corNota(destaque.nota ?? 0),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(destaque.nota.toString()),
        Image.network(destaque.logoTimeMandante!),
        Image.network(destaque.logoTimeVisitante!)
      ]),
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
    var dic = {"G": "Goleiro", "D": "Defensor", "M": "Meia", "F": "Atacante"};

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(15),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            color: const Color.fromARGB(255, 17, 34, 23),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (formacaoFavorita != null) ...[
            const Text("Formação favorita:",
                style: TextStyle(color: Colors.white, fontSize: 25),
                overflow: TextOverflow.ellipsis),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  color: const Color.fromARGB(255, 17, 34, 23),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Text(formacaoFavorita,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                  overflow: TextOverflow.ellipsis),
            )
          ] else ...[
            const Text("Posição favorita:",
                style: TextStyle(color: Colors.white, fontSize: 25),
                overflow: TextOverflow.ellipsis),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  color: const Color.fromARGB(255, 17, 34, 23),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Text(dic[posicaoFavorita].toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                  overflow: TextOverflow.ellipsis),
            )
          ],
          Text("Nota: ${estatisticas.nota?.toStringAsFixed(2) ?? 0}",
              style: const TextStyle(color: Colors.white, fontSize: 25),
              overflow: TextOverflow.ellipsis),
          Text("Passes certos: ${estatisticas.passesCertosTotal ?? 0}",
              style: const TextStyle(color: Colors.white, fontSize: 25),
              overflow: TextOverflow.ellipsis),
          Text("Assistencias: ${estatisticas.assistenciasTotal ?? 0}",
              style: const TextStyle(color: Colors.white, fontSize: 25),
              overflow: TextOverflow.ellipsis),
          Text("Dribles completos: ${estatisticas.driblesCompletosTotal ?? 0}",
              style: const TextStyle(color: Colors.white, fontSize: 25),
              overflow: TextOverflow.ellipsis),
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
                      "O jogador tem média $value acima da média geral de ${posicoes[posicaofav]} da série A. ",
                  style: const TextStyle(color: Colors.white)),
              TextSpan(
                  text: jogadorValue.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.green)),
              const TextSpan(
                  text: "/partida!", style: TextStyle(color: Colors.white)),
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
                      "O jogador tem média $value abaixo da média geral de ${posicoes[posicaofav]} da série A. ",
                  style: const TextStyle(color: Colors.white)),
              TextSpan(
                  text: jogadorValue.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.green)),
              const TextSpan(
                  text: "/partida.", style: TextStyle(color: Colors.white)),
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
                      "O jogador tem média $value abaixo da média geral de ${posicoes[posicaofav]} da série A. ",
                  style: const TextStyle(color: Colors.white)),
              TextSpan(
                  text: jogadorValue.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.red)),
              const TextSpan(
                  text: "/partida!", style: TextStyle(color: Colors.white)),
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
                      "O jogador tem média $value acima da média geral de ${posicoes[posicaofav]} da série A. ",
                  style: const TextStyle(color: Colors.white)),
              TextSpan(
                  text: jogadorValue.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.red)),
              const TextSpan(
                  text: "/partida.", style: TextStyle(color: Colors.white)),
            ])),
          ));
        }
      });
    }
    return lista;
  }
}
