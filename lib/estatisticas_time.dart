import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scout/repository/teamsrepository.dart';
import 'package:scout/util/util.dart';

class TimeEstatisticas extends StatefulWidget {
  final int idTime;
  final void Function(int) onPlayerClick;
  const TimeEstatisticas(
      {super.key, required this.idTime, required this.onPlayerClick});

  @override
  State<StatefulWidget> createState() {
    return _TimeEstatisticaState();
  }
}

class _TimeEstatisticaState extends State<TimeEstatisticas> {
  TimesRepository timesRepository = TimesRepository();
  TextEditingController controller = TextEditingController();
  bool carregando = false;
  bool valorSwitch = true;
  String? dropDownValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setState(() {
      carregando = true;
    });

    await timesRepository.getInfo(widget.idTime);

    setState(() {
      controller.text = timesRepository.formacoes[0];
      dropDownValue = timesRepository.formacoes.first;
      timesRepository = timesRepository;

      carregando = false;
    });
  }

  Future<void> atualizaFormacao(String formacao) async {
    setState(() {
      carregando = true;
    });

    await timesRepository.updateFormacao(widget.idTime, formacao);

    setState(() {
      controller.text = formacao;
      timesRepository = timesRepository;
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
        margin: const EdgeInsets.all(50),
        child: !carregando
            ? Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            CachedNetworkImage(
                              width: fatorDeEscalaMenor(90, context),
                              imageUrl: timesRepository.infoTime.logo!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/images/error_image.png'),
                            ),
                            Text(
                              timesRepository.infoTime.nome ?? 'Carregando...',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fatorDeEscalaMenor(25, context)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(color: Colors.green)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  menuMaxHeight: 300,
                                  dropdownColor: Colors.green,
                                  value: dropDownValue,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMenor(25, context)),
                                  items: [
                                    for (String i in timesRepository.formacoes)
                                      DropdownMenuItem(
                                          value: i,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(i),
                                          )),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        dropDownValue = value;
                                        atualizaFormacao(value);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ]),
                          Row(
                            children: [
                              Text(
                                "Aproveitamento na formação:",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fatorDeEscalaMenor(25, context)),
                              ),
                              containerNota(timesRepository.aproveitamento
                                  .getAproveitamento()),
                            ],
                          ),
                          constroiFormacao(controller.text, timesRepository),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Vitorias: ${timesRepository.aproveitamento.vitorias}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fatorDeEscalaMenor(25, context)),
                              ),
                              Text(
                                "Empates: ${timesRepository.aproveitamento.empates}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fatorDeEscalaMenor(25, context)),
                              ),
                              Text(
                                "Derrotas: ${timesRepository.aproveitamento.derrotas}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fatorDeEscalaMenor(25, context)),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: fatorDeEscalaMenor(300, context),
                                      decoration: BoxDecoration(
                                          color: valorSwitch
                                              ? const Color.fromARGB(
                                                  68, 34, 197, 94)
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
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                            side: const BorderSide(
                                                                color: Colors
                                                                    .green)),
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
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .red)),
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
                                                child: Column(
                                              children: [
                                                for (var i
                                                    in grandeComparacao())
                                                  i
                                              ],
                                            )),
                                          ),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget constroiFormacao(String formacao, TimesRepository timesRepository) {
    List<int> formacaoList = [
      for (String i in formacao.split("-")) int.parse(i)
    ];
    List<int> mei = formacaoList.sublist(1, formacaoList.length - 1);
    int atk = formacaoList.last;
    List<List<Jogador>> buffer = [];
    int start = 0;

    for (int i in mei) {
      buffer.add(timesRepository.meias.sublist(start, start + i));
      start += i;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.green,
          child: SizedBox(
            height: fatorDeEscalaMenor(400, context),
            width: fatorDeEscalaMenor(600, context),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {
                        widget.onPlayerClick(timesRepository.goleiro.id!);
                      },
                      child: imagemJogador(timesRepository.goleiro.image)),
                  Column(
                      //coluna zagueiros
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var i = 0; i < formacaoList[0]; i++)
                          GestureDetector(
                              onTap: () {
                                widget.onPlayerClick(
                                    timesRepository.defensores[i].id!);
                              },
                              child: imagemJogador(
                                  timesRepository.defensores[i].image)),
                      ]),
                  for (List<Jogador> i in buffer)
                    Column(
                        //colunas meias
                        mainAxisAlignment: i.length != 1
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.center,
                        children: [
                          if (i.length == 2) Container(),
                          for (Jogador j in i)
                            GestureDetector(
                                onTap: () {
                                  widget.onPlayerClick(j.id!);
                                },
                                child: imagemJogador(j.image)),
                          if (i.length == 2) Container(),
                        ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (atk == 2) Container(),
                        for (var z = 0;
                            z < timesRepository.atacantes.length;
                            z++)
                          GestureDetector(
                              onTap: () {
                                widget.onPlayerClick(
                                    timesRepository.atacantes[z].id!);
                              },
                              child: imagemJogador(
                                  timesRepository.atacantes[z].image)),
                        if (atk == 2) Container(),
                      ]),
                ]),
          ),
        ),
        const Text(
          "*Jogadores com mais minutos nessa formação",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Widget imagemJogador(String? url) {
    if (url == null) {
      return CircleAvatar(
        radius: fatorDeEscalaMenor(25, context),
        backgroundImage: const AssetImage('assets/images/error_image.png'),
      );
    }

    return CircleAvatar(
      radius: fatorDeEscalaMenor(25, context),
      backgroundImage: NetworkImage(url),
    );
  }

  Widget containerNota(double nota) {
    MaterialColor cor = Colors.green;

    if (nota < 60 && nota > 40) {
      cor = Colors.amber;
    } else if (nota < 40) {
      cor = Colors.red;
    } else {
      cor = Colors.green;
    }
    Widget x = Container(
      margin: EdgeInsets.all(fatorDeEscalaMenor(10, context)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: cor, borderRadius: const BorderRadius.all(Radius.circular(5))),
      padding: EdgeInsets.all(fatorDeEscalaMenor(20, context)),
      child: Text("${nota.toStringAsFixed(2)}%"),
    );

    return x;
  }

  List<Widget> grandeComparacao() {
    final descricoes = {
      'defensores': {0: "Duelos ganhos", 1: "Desarmes", 2: "Bloqueios"},
      'meias': {0: "Passes certos", 1: "Assistencias", 2: "Chances criadas"},
      'atacantes': {0: "Gols", 1: "Assistencias", 2: "Chutes no gol"},
    };

    final grupos = {
      'defensores': {'jogadores': timesRepository.defensores, 'mediaIndex': 0},
      'meias': {'jogadores': timesRepository.meias, 'mediaIndex': 1},
      'atacantes': {'jogadores': timesRepository.atacantes, 'mediaIndex': 2},
    };

    final List<Widget> widgets = [];

    for (var grupo in grupos.entries) {
      final nomeGrupo = grupo.key;
      final jogadores = grupo.value['jogadores'] as List<Jogador>;
      final mediaIndex = grupo.value['mediaIndex'] as int;
      final descricao = descricoes[nomeGrupo]!;
      final mediaStats = timesRepository.medias[mediaIndex].getLista();

      for (var jogador in jogadores) {
        final stats = jogador.estatisticas.getLista();

        for (int i = 0; i < stats.length; i++) {
          final valorJogador = stats[i];
          final valorMedia = mediaStats[i];

          final bool condicao = valorSwitch
              ? valorJogador > valorMedia
              : valorJogador < valorMedia;

          if (condicao) {
            widgets.add(Container(
              margin: const EdgeInsets.all(10),
              child: Text.rich(
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: fatorDeEscalaMenor(20, context)),
                TextSpan(children: [
                  TextSpan(
                      text: "${jogador.nome} - ${descricao[i]}: ",
                      style: const TextStyle(color: Colors.white)),
                  TextSpan(
                      text: valorJogador.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.green)),
                  const TextSpan(
                      text: "/partida.", style: TextStyle(color: Colors.white))
                ]),
              ),
            ));
          }
        }
      }
    }

    return widgets;
  }
}
