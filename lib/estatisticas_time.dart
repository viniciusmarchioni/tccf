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
  bool value = false;
  Tipos? tipo;
  String formacaoSelecionada = '';
  final timesRepository = TimesRepository();
  List<String> formacoes = [];
  @override
  void initState() {
    super.initState();
    _loadFormacoes();
  }

  Future<void> _loadFormacoes() async {
    List<String> fetchedFormacoes =
        await timesRepository.updateFormacoes(widget.idTime);
    setState(() {
      formacoes = fetchedFormacoes;
      if (formacoes.isNotEmpty) {
        formacaoSelecionada = formacoes[0]; // Define um valor padrão
      }
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
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      DropdownMenu(
                          onSelected: (value) {
                            setState(() {
                              formacaoSelecionada =
                                  value ?? timesRepository.formacoes[0];
                            });
                          },
                          requestFocusOnTap: false,
                          dropdownMenuEntries: [
                            for (String i in formacoes)
                              DropdownMenuEntry(value: i, label: i)
                          ]),
                    ],
                  ),
                  FutureBuilder(
                    future: formacaoSelecionada == ''
                        ? timesRepository.updateJogadores(widget.idTime)
                        : timesRepository.updateJogadoresFormacao(
                            widget.idTime, formacaoSelecionada),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return constroiFormacao(
                            formacaoSelecionada == ''
                                ? formacoes[0]
                                : formacaoSelecionada,
                            timesRepository);
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
              ListaPros(
                formacao: formacaoSelecionada,
                id: widget.idTime,
              ),
              Container()
            ],
          ),
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
                  imagemJogador(
                      "https://media.api-sports.io/football/players/123759.png"),
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
  final int id;
  const ListaPros({super.key, required this.formacao, required this.id});

  @override
  State<StatefulWidget> createState() => _ListaProsState();
}

class _ListaProsState extends State<ListaPros> {
  bool switchValue = false;
  MediaRepository mediaRepository = MediaRepository();
  TimesRepository timesRepository = TimesRepository();

  List<_Estat> defeitos = [
    _Estat(
        "Maior número de gols sofridos na temporada. ", "1.75 ", "por jogo."),
    _Estat(
        "Maior número de derrotas consecutivas em casa. ", "5 ", "derrotas."),
    _Estat("Maior número de passes errados por jogo. ", "25 ", "passes."),
    _Estat("Menor aproveitamento de finalizações no gol. ", "15%", "."),
    _Estat("Maior número de faltas cometidas por jogo. ", "18 ", "faltas."),
    _Estat(
        "Maior número de cartões vermelhos por temporada. ", "4 ", "cartões."),
    _Estat("Maior média de dribles falhados por jogo. ", "4.2 ", "dribles."),
    _Estat("Maior número de gols contra. ", "3 ", "gols."),
    _Estat("Maior percentual de cruzamentos errados. ", "50%", "."),
    _Estat("Maior número de jogos sem marcar gol. ", "8 ", "jogos."),
  ];

  Future<void> _loadMedias() async {
    await mediaRepository
        .getMedia(widget.formacao == '' ? '4-2-3-1' : widget.formacao);
    await timesRepository.updateJogadoresFormacao(widget.id, widget.formacao);
    setState(() {
      mediaRepository = mediaRepository;
      timesRepository = timesRepository;
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
            value: switchValue,
            onChanged: (value) {
              setState(() {
                switchValue = value;
              });
            },
          ),
          if (!switchValue) ...[
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
                            text:
                                i.estatisticas.estatistica1?.toStringAsFixed(2),
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
                            text:
                                i.estatisticas.estatistica1?.toStringAsFixed(2),
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
                            text:
                                i.estatisticas.estatistica1?.toStringAsFixed(2),
                            style: const TextStyle(color: Colors.green)),
                        const TextSpan(text: "/partida!")
                      ]),
                    ))
            ]
          ] else ...[
            for (_Estat i in defeitos)
              Container(
                  margin: const EdgeInsets.all(10),
                  child: Text.rich(
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20),
                    TextSpan(children: [
                      TextSpan(text: i.desc),
                      TextSpan(
                          text: i.porcentagem,
                          style: const TextStyle(color: Colors.red)),
                      TextSpan(text: i.fim)
                    ]),
                  ))
          ],
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
