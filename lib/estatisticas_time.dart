import 'package:flutter/material.dart';
import 'package:scout/repository/teamsrepository.dart';

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
        decoration: const BoxDecoration(
            color: Color.fromARGB(158, 134, 132, 131),
            borderRadius: BorderRadius.all(Radius.circular(20))),
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
                        DropdownMenu(
                            controller: controller,
                            hintText: "Formação",
                            onSelected: (value) {
                              if (value != null) {
                                atualizaFormacao(value);
                              }
                            },
                            requestFocusOnTap: false,
                            dropdownMenuEntries: [
                              for (String i in timesRepository.formacoes)
                                DropdownMenuEntry(value: i, label: i),
                            ]),
                        constroiFormacao(controller.text, timesRepository),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                          Container(
                            margin: const EdgeInsets.all(50),
                            height: 300,
                            color: Colors.white,
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
                                            style:
                                                const TextStyle(fontSize: 20),
                                            TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "${i.nome} obteve uma média de desarmes maior que a média de defensores da Serie A. "),
                                              TextSpan(
                                                  text: i
                                                      .estatisticas.estatistica1
                                                      ?.toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      color: Colors.green)),
                                              const TextSpan(text: "/partida.")
                                            ]),
                                          ))
                                  ],
                                  for (Jogador i in timesRepository.meias) ...[
                                    if ((i.estatisticas.estatistica1 ?? 0) >
                                        (timesRepository
                                                .medias[1].estatistica1 ??
                                            0))
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text.rich(
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 20),
                                            TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "${i.nome} obteve uma média de passes certos acima da média de meias da Serie A. "),
                                              TextSpan(
                                                  text: i
                                                      .estatisticas.estatistica1
                                                      ?.toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      color: Colors.green)),
                                              const TextSpan(text: "/partida!")
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
                                            style:
                                                const TextStyle(fontSize: 20),
                                            TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "${i.nome} obteve uma média de gols acima dos atacantes da Serie A. "),
                                              TextSpan(
                                                  text: i
                                                      .estatisticas.estatistica1
                                                      ?.toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      color: Colors.green)),
                                              const TextSpan(text: "/partida!")
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
                                            style:
                                                const TextStyle(fontSize: 20),
                                            TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "${i.nome} obteve uma média de desarmes abaixo que a média de defensores da Serie A. "),
                                              TextSpan(
                                                  text: i
                                                      .estatisticas.estatistica1
                                                      ?.toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      color: Colors.red)),
                                              const TextSpan(text: "/partida.")
                                            ]),
                                          ))
                                  ],
                                  for (Jogador i in timesRepository.meias) ...[
                                    if ((i.estatisticas.estatistica1 ?? 0) <
                                        (timesRepository
                                                .medias[1].estatistica1 ??
                                            0))
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text.rich(
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 20),
                                            TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "${i.nome} obteve uma média de passes certos abaixo da média de meias da Serie A. "),
                                              TextSpan(
                                                  text: i
                                                      .estatisticas.estatistica1
                                                      ?.toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      color: Colors.red)),
                                              const TextSpan(text: "/partida!")
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
                                            style:
                                                const TextStyle(fontSize: 20),
                                            TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "${i.nome} obteve uma média de gols abaixo dos atacantes da Serie A. "),
                                              TextSpan(
                                                  text: i
                                                      .estatisticas.estatistica1
                                                      ?.toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      color: Colors.red)),
                                              const TextSpan(text: "/partida!")
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
            height: 400,
            width: 600,
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
        const Text("*Jogadores com mais minutos nessa formação")
      ],
    );
  }

  Widget imagemJogador(String? url) {
    if (url == null) {
      return const CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage('assets/images/error_image.png'),
      );
    }

    return CircleAvatar(
      radius: 25,
      backgroundImage: NetworkImage(url),
    );
  }
}
