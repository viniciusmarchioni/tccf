import 'package:flutter/material.dart';
import 'package:scout/repository/teamsrepository.dart';
import 'dart:math';
import 'package:scout/util/tipos.dart';

class TimeEstatisticas extends StatefulWidget {
  const TimeEstatisticas({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TimeEstatisticaState();
  }
}

class _TimeEstatisticaState extends State {
  // Aqui você corrige para State<Wid>
  bool value = false;
  Tipos? tipo;
  String formation = '';

  List<String> urlGkp = [
    "https://media.api-sports.io/football/players/123759.png", // Hugo Souza
    "https://media.api-sports.io/football/players/195499.png", // Matheus Donelli
  ];

  List<String> urlDef = [
    "https://media.api-sports.io/football/players/1085.png", // André Ramalho
    "https://media.api-sports.io/football/players/2411.png", // Fagner
    "https://media.api-sports.io/football/players/5794.png", // Rodrigo Garro
    "https://media.api-sports.io/football/players/9742.png", // Matheus Bidu
    "https://media.api-sports.io/football/players/9992.png", // Gustavo Henrique
    "https://media.api-sports.io/football/players/10085.png", // Cacá
    "https://media.api-sports.io/football/players/36784.png", // Diego Palacios
    "https://media.api-sports.io/football/players/47116.png", // Héctor Hernández
    "https://media.api-sports.io/football/players/63964.png", // Félix Torres
    "https://media.api-sports.io/football/players/80534.png", // Caetano
    "https://media.api-sports.io/football/players/160436.png", // Raniele
    "https://media.api-sports.io/football/players/237102.png", // Matheus Araújo
    "https://media.api-sports.io/football/players/361665.png", // Léo Mana
    "https://media.api-sports.io/football/players/363693.png", // Breno Bidon
  ];

  List<String> urlMei = [
    "https://media.api-sports.io/football/players/687.png", // Maycon
    "https://media.api-sports.io/football/players/2426.png", // André Carrillo
    "https://media.api-sports.io/football/players/2521.png", // Ángel Romero
    "https://media.api-sports.io/football/players/10067.png", // Alex Santana
    "https://media.api-sports.io/football/players/50268.png", // Igor Coronado
    "https://media.api-sports.io/football/players/53148.png", // José Martínez
    "https://media.api-sports.io/football/players/54093.png", // Hugo
  ];

  List<String> urlAtk = [
    "https://media.api-sports.io/football/players/667.png", // Memphis Depay
    "https://media.api-sports.io/football/players/9329.png", // Pedro Raul
    "https://media.api-sports.io/football/players/9577.png", // Charles
    "https://media.api-sports.io/football/players/10007.png", // Yuri Alberto
    "https://media.api-sports.io/football/players/10161.png", // Matheuzinho
    "https://media.api-sports.io/football/players/70299.png", // Talles Magno
    "https://media.api-sports.io/football/players/80534.png", // Caetano
    "https://media.api-sports.io/football/players/312615.png", // Giovane
    "https://media.api-sports.io/football/players/403953.png", // Ryan Gustavo
  ];

  void setTipo(String str) {
    setState(() {
      if (str == "Corinthians") {
        tipo = Tipos.time;
      } else if (str == "Coronado") {
        tipo = Tipos.jogador;
      } else {
        tipo = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timesRepository = TimesRepository();

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
                      const DropdownMenu(
                          requestFocusOnTap: false,
                          dropdownMenuEntries: [
                            DropdownMenuEntry(
                                value: "Brasileirão", label: 'Brasileirão'),
                            DropdownMenuEntry(
                                value: "Libertadores", label: 'Libertadores'),
                            DropdownMenuEntry(
                                value: "Paulistão", label: 'Paulistão')
                          ]),
                      DropdownMenu(
                          requestFocusOnTap: false,
                          onSelected: (value) {
                            setState(() {
                              formation = value ?? formation;
                            });
                          },
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: "4-4-2", label: '4-4-2'),
                            DropdownMenuEntry(value: "4-3-3", label: '4-3-3'),
                            DropdownMenuEntry(
                                value: "4-1-2-1-2", label: '4-1-2-1-2')
                          ]),
                    ],
                  ),
                  FutureBuilder(
                    future: formation == ''
                        ? timesRepository.updateJogadores(131)
                        : timesRepository.updateJogadoresFormacao(
                            131, formation),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return constroiFormacao('4-5-1', timesRepository);
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  //constroiFormacao(formation, timesRepository)
                ],
              ),
              const ListaPros(),
              Container()
            ],
          ),
        ));
  }

  Widget constroiFormacao(String formacao, TimesRepository timesRepository) {
    List<int> formacaoList = [
      for (String i in formacao.split("-")) int.parse(i)
    ];
    int def = formacaoList[0];
    List<int> mei = formacaoList.sublist(1, formacaoList.length - 1);
    int atk = formacaoList.last;
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
                  imagemJogador(urlGkp[Random().nextInt(urlGkp.length)]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0;
                            i < timesRepository.defensores.length;
                            i++)
                          imagemJogador(timesRepository.defensores[i].image ??
                              'https://compras.wiki.ufsc.br/images/thumb/5/56/Erro.png/600px-Erro.png?20180222192440'),
                      ]),
                  for (var i = 0; i < mei.length; i++)
                    Column(
                        mainAxisAlignment: mei[i] != 1
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        children: [
                          if (mei[i] == 2) Container(),
                          for (var j = 0; j < timesRepository.meias.length; j++)
                            imagemJogador(timesRepository.meias[j].image ??
                                'https://compras.wiki.ufsc.br/images/thumb/5/56/Erro.png/600px-Erro.png?20180222192440'),
                          if (mei[i] == 2) Container(),
                        ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
  const ListaPros({super.key});

  @override
  State<StatefulWidget> createState() => _ListaProsState();
}

class _ListaProsState extends State<ListaPros> {
  bool switchValue = false;

  List<_Estat> qualidades = [
    _Estat("Maior porcentagem de passes certos na Série A. ", "88.02%", "!"),
    _Estat(
        "Menor número de gols sofridos na temporada. ", "0.85 ", "por jogo."),
    _Estat(
        "Maior número de vitórias consecutivas em casa. ", "12 ", "vitórias!"),
    _Estat("Maior posse de bola média por jogo", "62.5%. ", "."),
    _Estat("Melhor aproveitamento de finalizações no gol. ", "45%", "!"),
    _Estat("Menor número de faltas cometidas por jogo. ", "9 ", "faltas."),
    _Estat(
        "Maior média de dribles bem sucedidos por jogo. ", "6.8 ", "dribles."),
    _Estat(
        "Menor número de cartões amarelos por temporada. ", "35 ", "cartões."),
    _Estat("Maior número de jogos sem sofrer gol. ", "18 ", "jogos!"),
    _Estat("Maior precisão em cruzamentos. ", "32%", "!"),
    _Estat(
        "Maior número de assistências na temporada. ", "25 ", "assistências."),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Column(
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
          for (_Estat i in qualidades)
            Container(
                margin: const EdgeInsets.all(10),
                child: Text.rich(
                  style: const TextStyle(fontSize: 20),
                  TextSpan(children: [
                    TextSpan(text: i.desc),
                    TextSpan(
                        text: i.porcentagem,
                        style: const TextStyle(color: Colors.green)),
                    TextSpan(text: i.fim)
                  ]),
                ))
        ] else ...[
          for (_Estat i in defeitos)
            Container(
                margin: const EdgeInsets.all(10),
                child: Text.rich(
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
    );
  }
}

class _Estat {
  late String desc;
  late String porcentagem;
  late String fim;

  _Estat(this.desc, this.porcentagem, this.fim);
}
