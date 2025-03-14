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
                const Text(
                  "Corinthians",
                  style: TextStyle(fontSize: 20),
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
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Gols: ${jogadorRepository.estatisticas?.golsTotal ?? 0}"),
                                  Text(
                                      "Assistencias: ${jogadorRepository.estatisticas?.assistenciasTotal ?? 0}"),
                                  Text(
                                      "Grandes chances criadas: ${jogadorRepository.estatisticas?.passesChavesTotal ?? 0}"),
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
                                value: valorSwitch,
                                onChanged: (value) {
                                  setState(() {
                                    valorSwitch = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (valorSwitch) ...[
                            for (Widget widget in grandeComparacao(
                                jogadorRepository.estatisticas,
                                jogadorRepository.mediaGeral,
                                jogadorRepository.posicaoFavorita,
                                valorSwitch)) ...[
                              widget,
                            ]
                          ] else ...[
                            for (Widget widget in grandeComparacao(
                                jogadorRepository.estatisticas,
                                jogadorRepository.mediaGeral,
                                jogadorRepository.posicaoFavorita,
                                valorSwitch)) ...[
                              widget,
                            ]
                          ],
                          Container(),
                        ]
                      ])
                : const Center(child: CircularProgressIndicator()),
          ),
        )
      ]),
    );
  }

  Widget containerNota(double nota) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      color: Colors.green,
      child: Text(nota.toString()),
    );
  }

  Widget containerAtributos(Estatisticas estatisticas, String? formacaoFavorita,
      String? posicaoFavorita) {
    return Container(
      width: 200,
      height: 125,
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(children: [
        if (formacaoFavorita != null) ...[
          Text("Formação favorita: $formacaoFavorita"),
        ] else ...[
          Text("Posição favorita: $posicaoFavorita"),
        ],
        Text("Nota: ${estatisticas.nota ?? 0}"),
        Text("Passes certos: ${estatisticas.passesCertosAvg ?? 0}"),
        Text("Assistencias: ${estatisticas.assistenciasTotal ?? 0}"),
        Text("Dribles completos: ${estatisticas.driblesCompletosTotal ?? 0}"),
      ]),
    );
  }

  List<Widget> grandeComparacao(Estatisticas? jogador, Estatisticas? mediaGeral,
      String? posicaofav, bool positivo) {
    List<Widget> lista = [];

    final atributos = {
      'impedimentosAvg': "impedimentos",
      'chutesAvg': "chutes",
      'chutesNoGolAvg': "chutes no gol",
      'golsAvg': "gols",
      'golsSofridosAvg': "gols sofridos",
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

    atributos.forEach((key, value) {
      double jogadorValue = jogador?.toJson()[key] ?? 0.0;
      double mediaValue = mediaGeral?.toJson()[key] ?? 0.0;

      if (positivo) {
        if (jogadorValue > mediaValue) {
          lista.add(Text(
              "O jogador tem média $value acima da média geral de ${posicoes[posicaofav]} da série A. $jogadorValue/partida! $mediaValue"));
        }
      } else {
        if (jogadorValue < mediaValue) {
          lista.add(Text(
              "O jogador tem média $value abaixo da média geral de ${posicoes[posicaofav]} da série A. $jogadorValue/partida! $mediaValue"));
        }
      }
    });
    return lista;
  }
}
