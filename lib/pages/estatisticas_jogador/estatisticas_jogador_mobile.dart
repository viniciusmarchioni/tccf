import 'package:flutter/material.dart';
import 'package:scout/repository/jogador_repository.dart';
import 'package:scout/util/util.dart';

class JogadorEstatisticasMobile extends StatefulWidget {
  final int idJogador;
  const JogadorEstatisticasMobile({super.key, required this.idJogador});

  @override
  State<StatefulWidget> createState() => _JogadorEstatisticaState();
}

class _JogadorEstatisticaState extends State<JogadorEstatisticasMobile> {
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
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            color: const Color.fromARGB(255, 17, 34, 23),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.all(fatorDeEscalaMobile(15, context)),
        child: Column(
          children: [
            Text(
              jogadorRepository.jogador.nome ?? "Carregando...",
              style: TextStyle(
                  fontSize: fatorDeEscalaMobile(35, context),
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: jogadorRepository.jogador.image == null
                  ? null
                  : NetworkImage(jogadorRepository.jogador.image!),
              radius: fatorDeEscalaMobile(100, context),
            ),
            Text(
              jogadorRepository.nomeTime ?? "Carregando...",
              style: TextStyle(
                  fontSize: fatorDeEscalaMobile(20, context),
                  color: Colors.white),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: fatorDeEscalaMobile(15, context)),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.green)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Colors.green,
                  value: dropDownValue,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fatorDeEscalaMobile(25, context)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  geral ? "Desempenho Geral:" : "Desempenho na formação:",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                containerNota(jogadorRepository.estatisticas?.nota ?? 0)
              ],
            ),
            estatisticasPosicao(),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Destaques:",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fatorDeEscalaMobile(18, context))),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(),
                      for (Destaque i in jogadorRepository.destaques)
                        destaque(i),
                      Container(),
                    ]),
              ),
            ]),
            Container(
              height: fatorDeEscalaMobile(300, context),
              margin: EdgeInsets.symmetric(
                  vertical: fatorDeEscalaMobile(10, context)),
              decoration: BoxDecoration(
                  color: valorSwitch
                      ? const Color.fromARGB(68, 34, 197, 94)
                      : const Color.fromARGB(100, 197, 34, 37),
                  border: Border.all(
                      color: valorSwitch ? Colors.green : Colors.red,
                      width: 2)),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.green)),
                            onPressed: () {
                              setState(() {
                                valorSwitch = true;
                              });
                            },
                            child: Text(
                              "Pontos positivos",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: fatorDeEscalaMobile(15, context)),
                            )),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red)),
                            onPressed: () {
                              setState(() {
                                valorSwitch = false;
                              });
                            },
                            child: Text(
                              "Pontos negativos",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: fatorDeEscalaMobile(15, context)),
                            )),
                      ]),
                  Expanded(
                    child: SingleChildScrollView(
                        child: Row(
                      children: [
                        Expanded(
                          child: Column(children: [
                            for (var i in grandeComparacao(
                                jogadorRepository.estatisticas,
                                jogadorRepository.mediaGeral,
                                jogadorRepository.posicaoFavorita,
                                valorSwitch))
                              i
                          ]),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget estatisticasPosicao() {
    List<String> gerarEstatisticas(String? posicao) {
      final stats = jogadorRepository.estatisticas;
      switch (posicao) {
        case 'G':
          return [
            "Defesas: ${stats?.defesasTotal ?? 0}",
            "Gols sofridos: ${stats?.golsSofridosTotal ?? 0}",
          ];
        case 'D':
          return [
            "Duelos ganhos: ${stats?.duelosGanhosTotal ?? 0}",
            "Bloqueios: ${stats?.bloqueadosTotal ?? 0}",
            "Interceptação: ${stats?.interceptadosTotal ?? 0}",
          ];
        case 'M':
          return [
            "Passes certos: ${stats?.passesCertosTotal ?? 0}",
            "Grandes chances criadas: ${stats?.passesChavesTotal ?? 0}",
            "Dribles completos: ${stats?.driblesCompletosTotal ?? 0}",
          ];
        default:
          return [
            "Gols: ${stats?.golsTotal ?? 0}",
            "Chutes no gol: ${stats?.chutesNoGolTotal ?? 0}",
            "Assistências: ${stats?.assistenciasTotal ?? 0}",
          ];
      }
    }

    Widget buildTexto(String texto) {
      return Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fatorDeEscalaMobile(25, context),
        ),
      );
    }

    final posicaoFavorita = jogadorRepository.posicaoFavorita;
    final estatisticasTexto = gerarEstatisticas(posicaoFavorita);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: fatorDeEscalaMobile(10, context),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: fatorDeEscalaMobile(20, context),
              vertical: fatorDeEscalaMobile(20, context),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent, width: 2),
              color: const Color.fromARGB(255, 17, 34, 23),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...estatisticasTexto.map(buildTexto),
                buildTexto(
                    "Partidas jogadas: ${jogadorRepository.partidasJogadas ?? 0}"),
              ],
            ),
          ),
        ),
      ],
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
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 140),
      child: Container(
        height: fatorDeEscalaMobile(50, context),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: corNota(destaque.nota ?? 0),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(
            (destaque.nota ?? 0).toStringAsFixed(1),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fatorDeEscalaMobile(18, context)),
          ),
          Image.network(destaque.logoTimeMandante!),
          Image.network(destaque.logoTimeVisitante!)
        ]),
      ),
    );
  }

  Widget containerNota(double nota) {
    return Container(
      width: fatorDeEscalaMobile(50, context),
      height: fatorDeEscalaMobile(50, context),
      margin:
          EdgeInsets.symmetric(horizontal: fatorDeEscalaMobile(10, context)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: corNota(nota),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        nota.toStringAsFixed(2),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
            Text("Formação favorita:",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMobile(25, context)),
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
                      fontSize: fatorDeEscalaMobile(25, context)),
                  overflow: TextOverflow.ellipsis),
            )
          ] else ...[
            Text("Posição favorita:",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMobile(25, context)),
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
                      fontSize: fatorDeEscalaMobile(25, context)),
                  overflow: TextOverflow.ellipsis),
            )
          ],
          Text("Nota: ${estatisticas.nota?.toStringAsFixed(2) ?? 0}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMobile(25, context)),
              overflow: TextOverflow.ellipsis),
          Text("Passes certos: ${estatisticas.passesCertosTotal ?? 0}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMobile(25, context)),
              overflow: TextOverflow.ellipsis),
          Text("Assistencias: ${estatisticas.assistenciasTotal ?? 0}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMobile(25, context)),
              overflow: TextOverflow.ellipsis),
          Text("Dribles completos: ${estatisticas.driblesCompletosTotal ?? 0}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMobile(25, context)),
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

    if (positivo) {
      atributosPositivos.forEach((key, value) {
        double jogadorValue = jogador?.toJson()[key] ?? 0.0;
        double mediaValue = mediaGeral?.toJson()[key] ?? 0.0;

        if (jogadorValue > mediaValue) {
          lista.add(Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: "$value: "),
                TextSpan(
                    text: jogadorValue.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.green)),
                const TextSpan(text: "/partida!"),
              ]),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMobile(18, context)),
            ),
          ));
        }
      });
      atributosNegativos.forEach((key, value) {
        double jogadorValue = jogador?.toJson()[key] ?? 0.0;
        double mediaValue = mediaGeral?.toJson()[key] ?? 0.0;

        if (jogadorValue < mediaValue) {
          lista.add(Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: "$value: "),
                  TextSpan(
                      text: jogadorValue.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.green)),
                  const TextSpan(text: "/partida!"),
                ]),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMobile(18, context))),
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
            child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: "$value: "),
                  TextSpan(
                      text: jogadorValue.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.red)),
                  const TextSpan(text: "/partida."),
                ]),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMobile(18, context))),
          ));
        }
      });
      atributosNegativos.forEach((key, value) {
        double jogadorValue = jogador?.toJson()[key] ?? 0.0;
        double mediaValue = mediaGeral?.toJson()[key] ?? 0.0;

        if (jogadorValue > mediaValue) {
          lista.add(Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: "$value: ",
                      style: const TextStyle(color: Colors.white)),
                  TextSpan(
                      text: jogadorValue.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.red)),
                  const TextSpan(
                      text: "/partida.", style: TextStyle(color: Colors.white)),
                ]),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMobile(18, context))),
          ));
        }
      });
    }
    return lista;
  }
}
