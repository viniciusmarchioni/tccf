import 'package:flutter/material.dart';
import 'package:scout/repository/jogador_repository.dart';
import 'package:scout/util/util.dart';

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
      padding: EdgeInsets.all(fatorDeEscalaMenor(25, context)),
      margin: EdgeInsets.all(fatorDeEscalaMenor(50, context)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(fatorDeEscalaMenor(25, context)),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: jogadorRepository.jogador.image == null
                      ? null
                      : NetworkImage(jogadorRepository.jogador.image!),
                  radius: fatorDeEscalaMenor(150, context),
                ),
                Text(
                  jogadorRepository.jogador.nome ?? "Carregando...",
                  style: TextStyle(
                      fontSize: fatorDeEscalaMenor(35, context),
                      color: Colors.white),
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
                      menuMaxHeight: 300,
                      dropdownColor: Colors.green,
                      value: dropDownValue,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: fatorDeEscalaMenor(25, context)),
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
                Builder(
                  builder: (context) {
                    if (geral) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Desempenho geral:",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          containerNota(
                              jogadorRepository.estatisticas?.nota ?? 0)
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Desempenho na formação:",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          containerNota(
                              jogadorRepository.estatisticas?.nota ?? 0)
                        ],
                      );
                    }
                  },
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
                        Builder(
                          builder: (context) {
                            List<Widget> estatisticas = [];
                            String? posicaoFavorita =
                                jogadorRepository.posicaoFavorita;

                            if (posicaoFavorita == 'G') {
                              estatisticas.add(Text(
                                  "Defesas: ${jogadorRepository.estatisticas?.defesasTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                              estatisticas.add(Text(
                                  "Gols sofridos: ${jogadorRepository.estatisticas?.golsSofridosTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                            } else if (posicaoFavorita == 'D') {
                              estatisticas.add(Text(
                                  "Duelos ganhos: ${jogadorRepository.estatisticas?.duelosGanhosTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                              estatisticas.add(Text(
                                  "Bloqueios: ${jogadorRepository.estatisticas?.bloqueadosTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                              estatisticas.add(Text(
                                  "Interceptação: ${jogadorRepository.estatisticas?.interceptadosTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                            } else if (posicaoFavorita == 'M') {
                              estatisticas.add(Text(
                                  "Passes certos: ${jogadorRepository.estatisticas?.passesCertosTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                              estatisticas.add(Text(
                                  "Grandes chances criadas: ${jogadorRepository.estatisticas?.passesChavesTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                              estatisticas.add(Text(
                                  "Dribles completos: ${jogadorRepository.estatisticas?.driblesCompletosTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                            } else {
                              estatisticas.add(Text(
                                  "Gols: ${jogadorRepository.estatisticas?.golsTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                              estatisticas.add(Text(
                                  "Chutes no gol: ${jogadorRepository.estatisticas?.chutesNoGolTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                              estatisticas.add(Text(
                                  "Assistencias: ${jogadorRepository.estatisticas?.assistenciasTotal ?? 0}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context))));
                            }

                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (Widget i in estatisticas) i,
                                  Text(
                                      "Partidas jogadas: ${jogadorRepository.partidasJogadas ?? 0}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              fatorDeEscalaMenor(25, context))),
                                ]);
                          },
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: fatorDeEscalaMenor(300, context),
                                decoration: BoxDecoration(
                                    color: valorSwitch
                                        ? const Color.fromARGB(68, 34, 197, 94)
                                        : const Color.fromARGB(
                                            100, 197, 34, 37),
                                    border: Border.all(
                                        color: valorSwitch
                                            ? Colors.green
                                            : Colors.red,
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
                                                style: TextStyle(
                                                    color: Colors.green),
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
                                                style: TextStyle(
                                                    color: Colors.red),
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
                                    )
                                  ],
                                ),
                              ),
                              const Text(
                                "*Compração com a média geral entre jogadores da posição na serie A",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
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
      height: fatorDeEscalaMenor(50, context),
      width: fatorDeEscalaMenor(150, context),
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
        width: fatorDeEscalaMenor(50, context),
        height: fatorDeEscalaMenor(50, context),
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

    final pos = jogadorRepository.posicaoFavorita ?? "M";

    List<Widget> est = [];

    if (pos == "G") {
      est.add(
        Text("Defesas: ${estatisticas.defesasTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
      est.add(
        Text("Gols sofridos: ${estatisticas.golsSofridosTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
    } else if (pos == "D") {
      est.add(
        Text("Duelos ganhos: ${estatisticas.duelosGanhosTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
      est.add(
        Text("Bloqueios: ${estatisticas.bloqueadosTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
      est.add(
        Text("Interceptação: ${estatisticas.interceptadosTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
    } else if (pos == "M") {
      est.add(
        Text("Passes certos: ${estatisticas.passesCertosTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
      est.add(
        Text("Grandes chances criadas: ${estatisticas.passesChavesTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
      est.add(
        Text("Dribles completos: ${estatisticas.driblesCompletosTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
    } else {
      est.add(
        Text("Gols: ${estatisticas.golsTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
      est.add(
        Text("Assistências: ${estatisticas.assistenciasTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
      est.add(
        Text("Chutes no gol: ${estatisticas.chutesNoGolTotal ?? 0}",
            style: TextStyle(
                color: Colors.white, fontSize: fatorDeEscalaMenor(25, context)),
            overflow: TextOverflow.ellipsis),
      );
    }

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
            Text("Formação favorita:",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMenor(25, context)),
                overflow: TextOverflow.ellipsis),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  color: const Color.fromARGB(255, 17, 34, 23),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Text(formacaoFavorita,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fatorDeEscalaMenor(25, context)),
                  overflow: TextOverflow.ellipsis),
            )
          ] else ...[
            Text("Posição favorita:",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMenor(25, context)),
                overflow: TextOverflow.ellipsis),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  color: const Color.fromARGB(255, 17, 34, 23),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Text(dic[posicaoFavorita].toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fatorDeEscalaMenor(25, context)),
                  overflow: TextOverflow.ellipsis),
            )
          ],
          Text("Nota: ${estatisticas.nota?.toStringAsFixed(2) ?? 0}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMenor(25, context)),
              overflow: TextOverflow.ellipsis),
          for (var i in est) i
        ]),
      ),
    );
  }

  List<Widget> grandeComparacao(
    Estatisticas? jogador,
    Estatisticas? mediaGeral,
    String? posicaofav,
    bool positivo,
  ) {
    final lista = <Widget>[];

    final atributosPositivos = {
      'chutesAvg': "Chutes",
      'chutesNoGolAvg': "Chutes no gol",
      'golsAvg': "Gols",
      'assistenciasAvg': "Assistências",
      'defesasAvg': "Defesas",
      'passesAvg': "Passes",
      'passesChavesAvg': "Chances criadas",
      'passesCertosAvg': "Passes certos",
      'desarmesAvg': "Desarmes",
      'bloqueadosAvg': "Bloqueios",
      'interceptadosAvg': "Interceptações",
      'duelosAvg': "Duelos",
      'duelosGanhosAvg': "Duelos ganhos",
      'driblesTentadosAvg': "Dribles tentados",
      'driblesCompletosAvg': "Dribles completos",
      'jogadoresPassadosAvg': "Jogadores passados",
      'faltasSofridasAvg': "Faltas sofridas",
    };

    final atributosNegativos = {
      'impedimentosAvg': "Impedimentos",
      'faltasCometidasAvg': "Faltas cometidas",
      'cartoesAmarelosAvg': "Cartões amarelos",
      'cartoesVermelhosAvg': "Cartões vermelhos",
      'penaltisCometidosAvg': "Pênaltis cometidos"
    };

    void compararAtributos(
      Map<String, String> atributos,
      bool Function(double jogador, double media) condicao,
      Color corTexto,
      String sufixo,
    ) {
      atributos.forEach((key, label) {
        final jogadorValor = jogador?.toJson()[key] ?? 0.0;
        final mediaValor = mediaGeral?.toJson()[key] ?? 0.0;

        if (condicao(jogadorValor, mediaValor)) {
          lista.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "$label: ",
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: jogadorValor.toStringAsFixed(2),
                      style: TextStyle(color: corTexto),
                    ),
                    TextSpan(
                      text: sufixo,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                style: TextStyle(fontSize: fatorDeEscalaMenor(20, context)),
              ),
            ),
          );
        }
      });
    }

    if (positivo) {
      compararAtributos(
        atributosPositivos,
        (j, m) => j > m,
        Colors.green,
        "/partida!",
      );
      compararAtributos(
        atributosNegativos,
        (j, m) => j < m,
        Colors.green,
        "/partida!",
      );
    } else {
      compararAtributos(
        atributosPositivos,
        (j, m) => j < m,
        Colors.red,
        "/partida.",
      );
      compararAtributos(
        atributosNegativos,
        (j, m) => j > m,
        Colors.red,
        "/partida.",
      );
    }

    return lista;
  }
}
