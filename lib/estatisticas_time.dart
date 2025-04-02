import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scout/repository/teamsrepository.dart';
import 'package:scout/util/util.dart';

class TimeEstatisticas extends StatefulWidget {
  final int idTime;
  const TimeEstatisticas({super.key, required this.idTime});

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
        alignment: Alignment.topLeft,
        child: !carregando
            ? Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.green)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                dropdownColor: Colors.green,
                                value: dropDownValue,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fatorDeEscalaMenor(25, context)),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        Container(
                          margin:
                              EdgeInsets.all(fatorDeEscalaMenor(40, context)),
                          height: fatorDeEscalaMenor(300, context),
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
                                          style: TextStyle(color: Colors.green),
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
                                    child: Column(
                                  children: [
                                    if (valorSwitch) ...[
                                      for (Jogador i
                                          in timesRepository.defensores) ...[
                                        if ((i.estatisticas.estatistica1 ?? 0) >
                                            (timesRepository
                                                    .medias[0].estatistica1 ??
                                                0))
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Text.rich(
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        fatorDeEscalaMenor(
                                                            20, context)),
                                                TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "${i.nome} obteve uma média de desarmes maior que a média de defensores da Serie A. ",
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                  TextSpan(
                                                      text: i.estatisticas
                                                          .estatistica1
                                                          ?.toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          color: Colors.green)),
                                                  const TextSpan(
                                                      text: "/partida.",
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ]),
                                              ))
                                      ],
                                      for (Jogador i
                                          in timesRepository.meias) ...[
                                        if ((i.estatisticas.estatistica1 ?? 0) >
                                            (timesRepository
                                                    .medias[1].estatistica1 ??
                                                0))
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Text.rich(
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        fatorDeEscalaMenor(
                                                            20, context)),
                                                TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "${i.nome} obteve uma média de passes certos acima da média de meias da Serie A. ",
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                  TextSpan(
                                                      text: i.estatisticas
                                                          .estatistica1
                                                          ?.toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          color: Colors.green)),
                                                  const TextSpan(
                                                      text: "/partida!",
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ]),
                                              ))
                                      ],
                                      for (Jogador i
                                          in timesRepository.atacantes) ...[
                                        if ((i.estatisticas.estatistica1 ?? 0) >
                                            (timesRepository
                                                    .medias[2].estatistica1 ??
                                                0))
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Text.rich(
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        fatorDeEscalaMenor(
                                                            20, context)),
                                                TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "${i.nome} obteve uma média de gols acima dos atacantes da Serie A. ",
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                  TextSpan(
                                                      text: i.estatisticas
                                                          .estatistica1
                                                          ?.toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          color: Colors.green)),
                                                  const TextSpan(
                                                      text: "/partida!",
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ]),
                                              ))
                                      ]
                                    ] else ...[
                                      for (Jogador i
                                          in timesRepository.defensores) ...[
                                        if ((i.estatisticas.estatistica1 ?? 0) <
                                            (timesRepository
                                                    .medias[0].estatistica1 ??
                                                0))
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Text.rich(
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        fatorDeEscalaMenor(
                                                            20, context)),
                                                TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "${i.nome} obteve uma média de desarmes abaixo que a média de defensores da Serie A. ",
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                  TextSpan(
                                                      text: i.estatisticas
                                                          .estatistica1
                                                          ?.toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          color: Colors.red)),
                                                  const TextSpan(
                                                      text: "/partida.",
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ]),
                                              ))
                                      ],
                                      for (Jogador i
                                          in timesRepository.meias) ...[
                                        if ((i.estatisticas.estatistica1 ?? 0) <
                                            (timesRepository
                                                    .medias[1].estatistica1 ??
                                                0))
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Text.rich(
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        fatorDeEscalaMenor(
                                                            20, context)),
                                                TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "${i.nome} obteve uma média de passes certos abaixo da média de meias da Serie A. ",
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                  TextSpan(
                                                      text: i.estatisticas
                                                          .estatistica1
                                                          ?.toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          color: Colors.red)),
                                                  const TextSpan(
                                                      text: "/partida!",
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ]),
                                              ))
                                      ],
                                      for (Jogador i
                                          in timesRepository.atacantes) ...[
                                        if ((i.estatisticas.estatistica1 ?? 0) <
                                            (timesRepository
                                                    .medias[2].estatistica1 ??
                                                0))
                                          Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Text.rich(
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        fatorDeEscalaMenor(
                                                            20, context)),
                                                TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "${i.nome} obteve uma média de gols abaixo dos atacantes da Serie A. ",
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                  TextSpan(
                                                      text: i.estatisticas
                                                          .estatistica1
                                                          ?.toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          color: Colors.red)),
                                                  const TextSpan(
                                                      text: "/partida!",
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ]),
                                              ))
                                      ]
                                    ],
                                  ],
                                )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container()
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
                  imagemJogador(timesRepository.goleiro.image),
                  Column(
                      //coluna zagueiros
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var i = 0; i < formacaoList[0]; i++)
                          imagemJogador(timesRepository.defensores[i].image),
                      ]),
                  for (List<Jogador> i in buffer)
                    Column(
                        //colunas meias
                        mainAxisAlignment: i.length != 1
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.center,
                        children: [
                          if (i.length == 2) Container(),
                          for (Jogador j in i) imagemJogador(j.image),
                          if (i.length == 2) Container(),
                        ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (atk == 2) Container(),
                        for (var z = 0;
                            z < timesRepository.atacantes.length;
                            z++)
                          imagemJogador(timesRepository.atacantes[z].image),
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
}
