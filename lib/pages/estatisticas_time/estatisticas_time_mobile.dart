import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scout/repository/teamsrepository.dart';
import 'package:scout/util/util.dart';

class TimeEstatisticasMobile extends StatefulWidget {
  final int idTime;
  final void Function(int) onPlayerClick;
  const TimeEstatisticasMobile(
      {super.key, required this.idTime, required this.onPlayerClick});

  @override
  State<StatefulWidget> createState() {
    return _TimeEstatisticaMobileState();
  }
}

class _TimeEstatisticaMobileState extends State<TimeEstatisticasMobile> {
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
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              color: const Color.fromARGB(255, 17, 34, 23),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          margin: const EdgeInsets.all(10),
          alignment: Alignment.topLeft,
          child: !carregando
              ? Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              width: fatorDeEscalaMobile(80, context),
                              imageUrl: timesRepository.infoTime.logo!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/images/error_image.png'),
                            ),
                            SizedBox(
                              width: fatorDeEscalaMobile(250, context),
                              child: Text(
                                timesRepository.infoTime.nome ??
                                    'Carregando...',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: fatorDeEscalaMobile(35, context),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]),
                      constroiFormacao(controller.text, timesRepository),
                      escolhaFormacao(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Aproveitamento na formação:",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          containerNota(timesRepository.aproveitamento
                              .getAproveitamento()),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: fatorDeEscalaMobile(20, context),
                                  vertical: fatorDeEscalaMobile(20, context)),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.greenAccent, width: 2),
                                  color: const Color.fromARGB(255, 17, 34, 23),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Column(children: [
                                Text(
                                  "Vitorias: ${timesRepository.aproveitamento.vitorias}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMobile(25, context)),
                                ),
                                Text(
                                  "Empates: ${timesRepository.aproveitamento.empates}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMobile(25, context)),
                                ),
                                Text(
                                  "Derrotas: ${timesRepository.aproveitamento.derrotas}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMobile(25, context)),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
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
                                      child: Text(
                                        "Pontos positivos",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: fatorDeEscalaMobile(
                                                15, context)),
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
                                      child: Text(
                                        "Pontos negativos",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: fatorDeEscalaMobile(
                                                15, context)),
                                      )),
                                ]),
                            Expanded(
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [for (var i in grandeComparacao()) i],
                              )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  Container escolhaFormacao(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: fatorDeEscalaMobile(15, context)),
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.green)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: Colors.green,
          value: dropDownValue,
          style: TextStyle(
              color: Colors.white, fontSize: fatorDeEscalaMobile(25, context)),
          items: [
            for (String i in timesRepository.formacoes)
              DropdownMenuItem(
                  value: i,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
    );
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: fatorDeEscalaMobile(15, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.green,
            child: SizedBox(
              height: fatorDeEscalaMobile(200, context),
              width: fatorDeEscalaMobile(600, context),
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
                          for (Jogador i in timesRepository.defensores)
                            GestureDetector(
                                onTap: () {
                                  widget.onPlayerClick(i.id!);
                                },
                                child: imagemJogador(i.image)),
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
      ),
    );
  }

  Widget imagemJogador(String? url) {
    if (url == null) {
      return CircleAvatar(
        radius: fatorDeEscalaMobile(15, context),
        backgroundImage: const AssetImage('assets/images/error_image.png'),
      );
    }

    return CircleAvatar(
      radius: fatorDeEscalaMobile(15, context),
      backgroundImage: NetworkImage(url),
    );
  }

  MaterialColor corNota(double nota) {
    if (nota >= 60) {
      return Colors.green;
    } else if (nota > 50) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
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
                style: TextStyle(fontSize: fatorDeEscalaMobile(12, context)),
                TextSpan(
                    children: [
                      TextSpan(text: "${jogador.nome} - ${descricao[i]}: "),
                      TextSpan(
                          text: valorJogador.toStringAsFixed(2),
                          style: const TextStyle(color: Colors.green)),
                      const TextSpan(text: "/partida.")
                    ],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fatorDeEscalaMobile(18, context))),
              ),
            ));
          }
        }
      }
    }

    return widgets;
  }
}
