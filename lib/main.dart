import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scout/estatisticas_jogador.dart';
import 'package:scout/estatisticas_time.dart';
import 'package:scout/ia.dart';
import 'package:scout/lista_resultados.dart';
import 'package:scout/pesquisa_avancada.dart';
import 'package:scout/repository/menu_repository.dart';
import 'package:scout/util/tipos.dart';
import 'package:scout/util/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScoutAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scout'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  Tipos? tipo;
  int idTime = 131; // ID Corinthians
  int idJogador = 10007; // ID Yuri
  String pesquisa = "C";
  bool carregando = false;
  MenuRepository menuRepository = MenuRepository();

  void vaiptime(int id) {
    setState(() {
      idTime = id;
      tipo = Tipos.time;
    });
  }

  @override
  void initState() {
    super.initState();
    if (tipo == null) {
      init();
    }
  }

  void vaipjogador(int id) {
    setState(() {
      idJogador = id;
      tipo = Tipos.jogador;
    });
  }

  void setTipo(String str) {
    setState(() {
      tipo = null;
      pesquisa = str;
    });

    setState(() {
      if (str == "") {
        tipo = null;
      } else {
        tipo = Tipos.pesquisa;
      }
    });
  }

  Future<void> init() async {
    setState(() {
      carregando = true;
    });

    await menuRepository.init();

    setState(() {
      menuRepository = menuRepository;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                child: Image.asset("assets/images/logo.png"),
                onTap: () {
                  setState(() {
                    tipo = null;
                  });
                },
              ),
              SizedBox(
                width: fatorDeEscalaMenor(300, context),
                child: TextField(
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(width: 2, color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(width: 2, color: Colors.white)),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: "Pesquise no Scout AI"),
                  onSubmitted: (value) {
                    setTipo(value);
                  },
                  controller: controller,
                ),
              ),
              OutlinedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(50, 0, 100, 55))),
                onPressed: () {
                  setState(() {
                    tipo = Tipos.pesquisaAvancada;
                  });
                },
                child: const Row(children: [
                  Icon(Icons.person_search, color: Colors.white),
                  Text(
                    "Estatisticas de jogadores",
                    style: TextStyle(color: Colors.white),
                  )
                ]),
              ),
            ],
          ),
        ),
        body: Builder(
          builder: (context) {
            if (tipo == Tipos.time) {
              return TimeEstatisticas(
                idTime: idTime,
              );
            } else if (tipo == Tipos.jogador) {
              return JogadorEstatisticas(
                idJogador: idJogador,
              );
            } else if (tipo == Tipos.pesquisa) {
              return ListaResultados(
                pesquisa,
                onTeamClick: vaiptime,
                onPlayerClick: vaipjogador,
              );
            } else if (tipo == Tipos.pesquisaAvancada) {
              return PesquisaAvancada(
                onPlayerClick: vaipjogador,
              );
            } else if (tipo == Tipos.ia) {
              return const Ia();
            } else {
              return Container(
                margin: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    menu(context),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.greenAccent,
                          child: const Text("Próximos Jogos"),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 2),
                              color: const Color.fromARGB(255, 17, 34, 23),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          width: fatorDeEscalaMenor(600, context),
                          child: Column(
                            children: [
                              Text(
                                "Jogadores em destaque",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fatorDeEscalaMenor(30, context)),
                              ),
                              CarouselSlider(
                                items: menuRepository.jogadoresDestaque
                                    .map((jogador) {
                                  return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          radius:
                                              fatorDeEscalaMenor(65, context),
                                          child: CircleAvatar(
                                              radius: fatorDeEscalaMenor(
                                                  60, context),
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      jogador.imagem!)),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              jogador.nome!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fatorDeEscalaMenor(
                                                      25, context)),
                                            ),
                                            Text(
                                              jogador.nomeTime!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fatorDeEscalaMenor(
                                                      20, context)),
                                            ),
                                            Text(
                                              "Desempenho: ${jogador.nota!.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fatorDeEscalaMenor(
                                                      20, context)),
                                            ),
                                          ],
                                        )
                                      ]);
                                }).toList(),
                                options: CarouselOptions(
                                    height: fatorDeEscalaMenor(200, context),
                                    viewportFraction: 1,
                                    animateToClosest: true,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: true,
                                    autoPlay: true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ultimosJogos(context),
                  ],
                ),
              );
            }
          },
        ));
  }

  Container ultimosJogos(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 17, 34, 23),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.green)),
      padding: EdgeInsets.all(fatorDeEscalaMenor(15, context)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("Últimos jogos",
            style: TextStyle(
                color: Colors.white,
                fontSize: fatorDeEscalaMenor(30, context))),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [for (var i in menuRepository.ultimasPartidas) jogo(i)],
          ),
        ))
      ]),
    );
  }

  Widget jogo(Partida partida) {
    const tamanhoTime = 40.0;
    const tamanhoFonteDia = 15.0;
    const tamanhoFonteTime = 20.0;
    const dic = {
      1: "Domingo",
      2: "Segunda",
      3: "Terça",
      4: "Quarta",
      5: "Quinta",
      6: "Sexta",
      7: "Sábado",
    };
    return Container(
      margin: EdgeInsets.symmetric(vertical: fatorDeEscalaMenor(10, context)),
      child: Column(children: [
        Text(
          "${partida.data?.hour}:${partida.data?.minute}-${dic[partida.data?.weekday]}-${partida.data?.day}/${partida.data?.month}",
          style: TextStyle(
              color: Colors.white,
              fontSize: fatorDeEscalaMenor(tamanhoFonteDia, context)),
        ),
        Row(
          children: [
            Text(
              partida.nomeMandante?.substring(0, 3).toUpperCase() ?? "...",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMenor(tamanhoFonteTime, context)),
            ),
            CachedNetworkImage(
              width: fatorDeEscalaMenor(tamanhoTime, context),
              imageUrl: partida.logoMandante!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/error_image.png'),
            ),
            Text(
              partida.golsMandante.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMenor(tamanhoFonteTime, context)),
            ),
            Image.asset("assets/images/vs.png",
                height: fatorDeEscalaMenor(tamanhoFonteTime, context)),
            Text(
              partida.golsVisitante.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMenor(tamanhoFonteTime, context)),
            ),
            CachedNetworkImage(
              width: fatorDeEscalaMenor(tamanhoTime, context),
              imageUrl: partida.logoVisitante!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/error_image.png'),
            ),
            Text(partida.nomeVisitante?.substring(0, 3).toUpperCase() ?? "...",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMenor(tamanhoFonteTime, context)))
          ],
        )
      ]),
    );
  }

  Container menu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 17, 34, 23),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.green)),
      padding: EdgeInsets.all(fatorDeEscalaMenor(15, context)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item("Tabela", Icons.emoji_events, () {}),
            _item("Times", Icons.sports_soccer_rounded, () {
              setTipo("Times");
            }),
            _item("Jogadores", Icons.person, () {
              setTipo("Jogadores");
            }),
            _item("Comparações", Icons.person_search, () {}),
            _item("Previsões IA", Icons.auto_awesome_rounded, () {
              setState(() {
                tipo = Tipos.ia;
              });
            }),
          ]),
    );
  }

  Widget _item(String titulo, IconData icon, Function fun) {
    return GestureDetector(
      onTap: () => fun(),
      child: Row(children: [
        Icon(icon, color: Colors.white, size: fatorDeEscalaMenor(60, context)),
        Text(
          titulo,
          style: TextStyle(
              color: Colors.white, fontSize: fatorDeEscalaMenor(30, context)),
        )
      ]),
    );
  }
}
