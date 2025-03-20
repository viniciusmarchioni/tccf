import 'package:flutter/material.dart';
import 'package:scout/repository/media_repository.dart';
import 'package:scout/repository/teamsrepository.dart';
import 'package:scout/util/tipos.dart';

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
                    ListaPros(
                      formacao: controller.text,
                      timesRepository: timesRepository,
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
                  imagemJogador(timesRepository.goleiro.image ??
                      'https://compras.wiki.ufsc.br/images/thumb/5/56/Erro.png/600px-Erro.png?20180222192440'),
                  Column(
                      //coluna zagueiros
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var i = 0; i < formacaoList[0]; i++)
                          imagemJogador(timesRepository.defensores[i].image ??
                              'https://compras.wiki.ufsc.br/images/thumb/5/56/Erro.png/600px-Erro.png?20180222192440'),
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
                            imagemJogador(j.image ??
                                'https://compras.wiki.ufsc.br/images/thumb/5/56/Erro.png/600px-Erro.png?20180222192440'),
                          if (i.length == 2) Container(),
                        ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (atk == 2) Container(),
                        for (var z = 0;
                            z < timesRepository.atacantes.length;
                            z++)
                          imagemJogador(timesRepository.atacantes[z].image ??
                              'https://compras.wiki.ufsc.br/images/thumb/5/56/Erro.png/600px-Erro.png?20180222192440'),
                        if (atk == 2) Container(),
                      ]),
                ]),
          ),
        ),
        const Text("*Jogadores com mais minutos nessa formação")
      ],
    );
  }

  Widget imagemJogador(String url) {
    return CircleAvatar(
      radius: 25,
      backgroundImage: NetworkImage(url),
    );
  }
}

class ListaPros extends StatefulWidget {
  final String formacao;
  final TimesRepository timesRepository;
  const ListaPros(
      {super.key, required this.formacao, required this.timesRepository});

  @override
  State<StatefulWidget> createState() => _ListaProsState();
}

class _ListaProsState extends State<ListaPros> {
  bool switchValue = true;
  MediaRepository mediaRepository = MediaRepository();
  TimesRepository timesRepository = TimesRepository();

  Future<void> _loadMedias() async {
    await mediaRepository.getMedia(widget.formacao);
    setState(() {
      timesRepository = widget.timesRepository;
      mediaRepository = mediaRepository;
    });
  }

  @override
  void initState() {
    super.initState();

    _loadMedias();
  }

  @override
  void didUpdateWidget(covariant ListaPros oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.formacao != oldWidget.formacao) {
      _loadMedias();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Switch(
            trackColor: switchValue
                ? const MaterialStatePropertyAll(Colors.green)
                : const MaterialStatePropertyAll(Colors.red),
            value: switchValue,
            onChanged: (value) {
              setState(() {
                switchValue = value;
              });
            },
          ),
          Container(
            margin: const EdgeInsets.all(50),
            height: 300,
            color: Colors.white,
            child: SingleChildScrollView(
                child: Column(
              children: [
                if (switchValue) ...[
                  for (Jogador i in timesRepository.defensores) ...[
                    if ((i.estatisticas.estatistica1 ?? 0) >
                        (mediaRepository.medias.desarmes ?? 0))
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Text.rich(
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                            TextSpan(children: [
                              TextSpan(
                                  text:
                                      "${i.nome} obteve uma média de desarmes maior que a média de defensores da Serie A. "),
                              TextSpan(
                                  text: i.estatisticas.estatistica1
                                      ?.toStringAsFixed(2),
                                  style: const TextStyle(color: Colors.green)),
                              const TextSpan(text: "/partida.")
                            ]),
                          ))
                  ],
                  for (Jogador i in timesRepository.meias) ...[
                    if ((i.estatisticas.estatistica1 ?? 0) >
                        (mediaRepository.medias.passesCertos ?? 0))
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Text.rich(
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                            TextSpan(children: [
                              TextSpan(
                                  text:
                                      "${i.nome} obteve uma média de passes certos acima da média de meias da Serie A. "),
                              TextSpan(
                                  text: i.estatisticas.estatistica1
                                      ?.toStringAsFixed(2),
                                  style: const TextStyle(color: Colors.green)),
                              const TextSpan(text: "/partida!")
                            ]),
                          ))
                  ],
                  for (Jogador i in timesRepository.atacantes) ...[
                    if ((i.estatisticas.estatistica1 ?? 0) >
                        (mediaRepository.medias.gols ?? 0))
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Text.rich(
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                            TextSpan(children: [
                              TextSpan(
                                  text:
                                      "${i.nome} obteve uma média de gols acima dos atacantes da Serie A. "),
                              TextSpan(
                                  text: i.estatisticas.estatistica1
                                      ?.toStringAsFixed(2),
                                  style: const TextStyle(color: Colors.green)),
                              const TextSpan(text: "/partida!")
                            ]),
                          ))
                  ]
                ] else ...[
                  for (Jogador i in timesRepository.defensores) ...[
                    if ((i.estatisticas.estatistica1 ?? 0) <
                        (mediaRepository.medias.desarmes ?? 0))
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Text.rich(
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                            TextSpan(children: [
                              TextSpan(
                                  text:
                                      "${i.nome} obteve uma média de desarmes abaixo que a média de defensores da Serie A. "),
                              TextSpan(
                                  text: i.estatisticas.estatistica1
                                      ?.toStringAsFixed(2),
                                  style: const TextStyle(color: Colors.red)),
                              const TextSpan(text: "/partida.")
                            ]),
                          ))
                  ],
                  for (Jogador i in timesRepository.meias) ...[
                    if ((i.estatisticas.estatistica1 ?? 0) <
                        (mediaRepository.medias.passesCertos ?? 0))
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Text.rich(
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                            TextSpan(children: [
                              TextSpan(
                                  text:
                                      "${i.nome} obteve uma média de passes certos abaixo da média de meias da Serie A. "),
                              TextSpan(
                                  text: i.estatisticas.estatistica1
                                      ?.toStringAsFixed(2),
                                  style: const TextStyle(color: Colors.red)),
                              const TextSpan(text: "/partida!")
                            ]),
                          ))
                  ],
                  for (Jogador i in timesRepository.atacantes) ...[
                    if ((i.estatisticas.estatistica1 ?? 0) <
                        (mediaRepository.medias.gols ?? 0))
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Text.rich(
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                            TextSpan(children: [
                              TextSpan(
                                  text:
                                      "${i.nome} obteve uma média de gols abaixo dos atacantes da Serie A. "),
                              TextSpan(
                                  text: i.estatisticas.estatistica1
                                      ?.toStringAsFixed(2),
                                  style: const TextStyle(color: Colors.red)),
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
    );
  }
}

class _Estat {
  late String desc;
  late String porcentagem;
  late String fim;

  _Estat(this.desc, this.porcentagem, this.fim);
}
