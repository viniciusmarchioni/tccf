import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scout/pages/estatisticas_jogador/estatisticas_jogador.dart';
import 'package:scout/pages/estatisticas_time/estatisticas_time.dart';
import 'package:scout/pages/ia/ia.dart';
import 'package:scout/pages/lista_resultados/lista_resultados.dart';
import 'package:scout/pages/menu/menu_mobile.dart';
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
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MyHomePage(title: 'Scout'),
        ),
        GoRoute(
          path: '/pesquisa/:pesquisa',
          builder: (context, state) {
            String pesquisa = state.pathParameters['pesquisa'] ?? "Times";
            return ListaResultados(pesquisa: pesquisa);
          },
        ),
        GoRoute(
          path: '/jogadores/:id',
          builder: (context, state) {
            int jogadorId = int.parse(state.pathParameters['id'] ?? '131');
            return JogadorEstatisticas(idJogador: jogadorId);
          },
        ),
        GoRoute(
          path: '/times/:id',
          builder: (context, state) {
            int timeId = int.parse(state.pathParameters['id'] ?? '10007');
            return TimeEstatisticas(
              idTime: timeId,
            );
          },
        ),
        GoRoute(
          path: '/ia/:mandante/:visitante',
          builder: (context, state) {
            String? mandante = state.pathParameters['mandante'];
            String? visitante = state.pathParameters['visitante'];
            return Ia(mandante: mandante, visitante: visitante);
          },
        ),
        GoRoute(
          path: '/ia',
          builder: (context, state) {
            return const Ia();
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'ScoutAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
        useMaterial3: true,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
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

  final dic = {
    1: "Domingo",
    2: "Segunda",
    3: "Terça",
    4: "Quarta",
    5: "Quinta",
    6: "Sexta",
    7: "Sábado",
  };

  @override
  void initState() {
    super.initState();
    if (tipo == null) {
      init();
    }
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
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (!sizingInformation.isDesktop) {
          return const MenuMobile();
        }
        return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                flexibleSpace: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Image.asset(
                        "assets/images/logo.png",
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: fatorDeEscalaMenor(300, context),
                      child: TextField(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.white)),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            hintText: "Pesquise no Scout AI"),
                        onSubmitted: (value) {
                          context.push("/pesquisa/$value");
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
                )),
            body: Container(
              margin: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  menu(context),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 2),
                              color: const Color.fromARGB(255, 17, 34, 23),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          width: fatorDeEscalaMenor(600, context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Próximos jogos",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fatorDeEscalaMenor(30, context)),
                              ),
                              CarouselSlider(
                                carouselController: CarouselSliderController(),
                                items: menuRepository.proximasPartidas
                                    .map((partida) {
                                  return Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //Mandante
                                            GestureDetector(
                                              onTap: () {
                                                context.push(
                                                    '/times/${partida.idMandante}');
                                              },
                                              child: Column(children: [
                                                Image.network(
                                                  partida.logoMandante!,
                                                  height: fatorDeEscalaMenor(
                                                      150, context),
                                                  width: fatorDeEscalaMenor(
                                                      150, context),
                                                ),
                                                Text(
                                                  partida.nomeMandante!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          fatorDeEscalaMenor(
                                                              20, context)),
                                                )
                                              ]),
                                            ),
                                            //Data do jogo
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${partida.data?.hour.toString().padLeft(2, '0')}:${partida.data?.minute.toString().padLeft(2, '0')}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            fatorDeEscalaMenor(
                                                                20, context)),
                                                  ),
                                                  Text(
                                                    dic[partida.data?.weekday]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            fatorDeEscalaMenor(
                                                                20, context)),
                                                  ),
                                                  Text(
                                                    "${partida.data?.day}/${partida.data?.month}/${(partida.data?.year ?? 0) - 2000}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            fatorDeEscalaMenor(
                                                                20, context)),
                                                  )
                                                ]),
                                            //Visitante
                                            GestureDetector(
                                              onTap: () {
                                                context.push(
                                                    '/times/${partida.idVisitante}');
                                              },
                                              child: Column(children: [
                                                Image.network(
                                                  height: fatorDeEscalaMenor(
                                                      150, context),
                                                  width: fatorDeEscalaMenor(
                                                      150, context),
                                                  partida.logoVisitante!,
                                                ),
                                                Text(
                                                  partida.nomeVisitante!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          fatorDeEscalaMenor(
                                                              20, context)),
                                                )
                                              ]),
                                            )
                                          ]),
                                      //Botão prever
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              style: const ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.green)),
                                              onPressed: () {
                                                context.push(
                                                    "/ia/${partida.nomeMandante}/${partida.nomeVisitante}");
                                              },
                                              child: Text(
                                                "Prever",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        fatorDeEscalaMenor(
                                                            20, context)),
                                              ))
                                        ],
                                      )
                                    ],
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                    height:
                                        fatorDeEscalaMenor(300 - 19, context),
                                    viewportFraction: 1,
                                    animateToClosest: true,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: true,
                                    autoPlay: true),
                              ),
                              Container()
                            ],
                          ),
                        ),
                      ),
                      //Carrossel jogadores em destaqu
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
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .push('/jogadores/${jogador.id}');
                                        },
                                        child: CircleAvatar(
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
            ));
      },
    );
  }

  Container navBarMobile(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            iconSize: fatorDeEscalaMobile(50, context),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ListaResultados(pesquisa: "Times")),
              );
            },
            icon: Image.asset("assets/images/escudo.png",
                height: 50, color: Colors.white),
          ),
          IconButton(
            iconSize: fatorDeEscalaMobile(50, context),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ListaResultados(pesquisa: "Jogadores")),
              );
            },
            color: Colors.white,
            icon: const Icon(Icons.person),
          ),
          IconButton(
            iconSize: fatorDeEscalaMobile(50, context),
            onPressed: () {
              setState(() {
                tipo = Tipos.pesquisaAvancada;
              });
            },
            color: Colors.white,
            icon: const Icon(Icons.person_search_rounded),
          ),
          IconButton(
            iconSize: fatorDeEscalaMobile(50, context),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Ia(
                          mandante: null,
                          visitante: null,
                        )),
              );
            },
            color: Colors.white,
            icon: const Icon(Icons.auto_awesome_rounded),
          ),
        ],
      ),
    );
  }

  SizedBox pesquisaMobile(BuildContext context) {
    return SizedBox(
      width: fatorDeEscalaMobile(300, context),
      child: TextField(
        decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 2, color: Colors.white)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 2, color: Colors.white)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            hintText: "Pesquise no Scout AI"),
        onSubmitted: (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListaResultados(
                      pesquisa: value,
                    )),
          );
        },
      ),
    );
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

    return Container(
      margin: EdgeInsets.symmetric(vertical: fatorDeEscalaMenor(10, context)),
      child: Column(children: [
        Text(
          "${partida.data?.hour.toString().padLeft(2, '0')}:${partida.data?.minute.toString().padLeft(2, '0')}-${dic[partida.data?.weekday]}-${partida.data?.day}/${partida.data?.month}",
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
            _item("Times", Icons.sports_soccer_rounded, () {
              context.push("/pesquisa/Times");
            }),
            _item("Jogadores", Icons.person, () {
              context.push("/pesquisa/Jogadores");
            }),
            _item("Comparações", Icons.person_search, () {
              setState(() {
                tipo = Tipos.pesquisaAvancada;
              });
            }),
            _item("Previsões IA", Icons.auto_awesome_rounded, () {
              context.push("/ia");
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
