import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scout/pages/estatisticas_jogador/estatisticas_jogador.dart';
import 'package:scout/pages/estatisticas_jogador/estatisticas_jogador_mobile.dart';
import 'package:scout/pages/estatisticas_time/estatisticas_time.dart';
import 'package:scout/pages/estatisticas_time/estatisticas_time_mobile.dart';
import 'package:scout/pages/ia/ia.dart';
import 'package:scout/pages/ia/ia_mobile.dart';
import 'package:scout/pages/lista_resultados/lista_resultados.dart';
import 'package:scout/pages/lista_resultados/lista_resultados_mobile.dart';
import 'package:scout/pages/menu/menu_mobile.dart';
import 'package:scout/pages/pesquisa_avancada/pesquisa_avancada.dart';
import 'package:scout/pages/pesquisa_avancada/pesquisa_avancada_mobile.dart';
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
  String? _carrousselMandante;
  String? _carrousselVisitante;

  final dic = {
    1: "Domingo",
    2: "Segunda",
    3: "Terça",
    4: "Quarta",
    5: "Quinta",
    6: "Sexta",
    7: "Sábado",
  };

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

  void vaipIA(String? mandante, String? visitante) {
    setState(() {
      _carrousselMandante = mandante;
      _carrousselVisitante = visitante;

      tipo = Tipos.ia;
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
            flexibleSpace: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (!sizingInformation.isDesktop) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      GestureDetector(
                        child: Image.asset(
                          "assets/images/logo.png",
                          scale: fatorDeEscalaMenorReverso(1, context),
                        ),
                        onTap: () {
                          setState(() {
                            tipo = null;
                          });
                        },
                      ),
                      Container(),
                    ],
                  );
                }
                return Row(
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
                );
              },
            )),
        body: Builder(
          builder: (context) {
            if (tipo == Tipos.time) {
              return ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  if (!sizingInformation.isDesktop) {
                    return Column(
                      children: [
                        pesquisaMobile(context),
                        Expanded(
                            child: TimeEstatisticasMobile(
                          idTime: idTime,
                          onPlayerClick: vaipjogador,
                        )),
                        navBarMobile(context)
                      ],
                    );
                  }
                  return TimeEstatisticas(
                    idTime: idTime,
                    onPlayerClick: vaipjogador,
                  );
                },
              );
            } else if (tipo == Tipos.jogador) {
              return ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  if (!sizingInformation.isDesktop) {
                    return Column(
                      children: [
                        pesquisaMobile(context),
                        Expanded(
                            child: JogadorEstatisticasMobile(
                                idJogador: idJogador)),
                        navBarMobile(context)
                      ],
                    );
                  }
                  return JogadorEstatisticas(
                    idJogador: idJogador,
                  );
                },
              );
            } else if (tipo == Tipos.pesquisa) {
              return ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  if (!sizingInformation.isDesktop) {
                    return Column(
                      children: [
                        pesquisaMobile(context),
                        Expanded(
                          child: ListaResultadosMobile(
                            pesquisa,
                            onTeamClick: vaiptime,
                            onPlayerClick: vaipjogador,
                          ),
                        ),
                        navBarMobile(context)
                      ],
                    );
                  }
                  return ListaResultados(
                    pesquisa,
                    onTeamClick: vaiptime,
                    onPlayerClick: vaipjogador,
                  );
                },
              );
            } else if (tipo == Tipos.pesquisaAvancada) {
              return ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  if (!sizingInformation.isDesktop) {
                    return Column(
                      children: [
                        pesquisaMobile(context),
                        Expanded(
                            child: PesquisaAvancadaMobile(
                                onPlayerClick: vaipjogador)),
                        navBarMobile(context)
                      ],
                    );
                  }
                  return PesquisaAvancada(
                    onPlayerClick: vaipjogador,
                  );
                },
              );
            } else if (tipo == Tipos.ia) {
              return ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  if (!sizingInformation.isDesktop) {
                    return Column(
                      children: [
                        pesquisaMobile(context),
                        Expanded(
                          child: IaMobile(
                            mandante: _carrousselMandante,
                            visitante: _carrousselVisitante,
                          ),
                        ),
                        navBarMobile(context)
                      ],
                    );
                  }
                  return Ia(
                    mandante: _carrousselMandante,
                    visitante: _carrousselVisitante,
                  );
                },
              );
            } else {
              return ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  if (!sizingInformation.isDesktop) {
                    return Column(
                      children: [
                        pesquisaMobile(context),
                        MenuMobile(
                          onPlayerClick: vaipjogador,
                          onTimeClick: vaiptime,
                          vaipIA: vaipIA,
                        ),
                        navBarMobile(context)
                      ],
                    );
                  }
                  return Container(
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
                                    border: Border.all(
                                        color: Colors.green, width: 2),
                                    color:
                                        const Color.fromARGB(255, 17, 34, 23),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                width: fatorDeEscalaMenor(600, context),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Próximos jogos",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              fatorDeEscalaMenor(30, context)),
                                    ),
                                    CarouselSlider(
                                      carouselController:
                                          CarouselSliderController(),
                                      items: menuRepository.proximasPartidas
                                          .map((partida) {
                                        return Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  //Mandante
                                                  GestureDetector(
                                                    onTap: () {
                                                      vaiptime(
                                                          partida.idMandante!);
                                                    },
                                                    child: Column(children: [
                                                      Image.network(
                                                        partida.logoMandante!,
                                                        height:
                                                            fatorDeEscalaMenor(
                                                                150, context),
                                                        width:
                                                            fatorDeEscalaMenor(
                                                                150, context),
                                                      ),
                                                      Text(
                                                        partida.nomeMandante!,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                fatorDeEscalaMenor(
                                                                    20,
                                                                    context)),
                                                      )
                                                    ]),
                                                  ),
                                                  //Data do jogo
                                                  Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "${partida.data?.hour.toString().padLeft(2, '0')}:${partida.data?.minute.toString().padLeft(2, '0')}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  fatorDeEscalaMenor(
                                                                      20,
                                                                      context)),
                                                        ),
                                                        Text(
                                                          dic[partida.data
                                                                  ?.weekday]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  fatorDeEscalaMenor(
                                                                      20,
                                                                      context)),
                                                        ),
                                                        Text(
                                                          "${partida.data?.day}/${partida.data?.month}/${(partida.data?.year ?? 0) - 2000}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  fatorDeEscalaMenor(
                                                                      20,
                                                                      context)),
                                                        )
                                                      ]),
                                                  //Visitante
                                                  GestureDetector(
                                                    onTap: () {
                                                      vaiptime(
                                                          partida.idVisitante!);
                                                    },
                                                    child: Column(children: [
                                                      Image.network(
                                                        height:
                                                            fatorDeEscalaMenor(
                                                                150, context),
                                                        width:
                                                            fatorDeEscalaMenor(
                                                                150, context),
                                                        partida.logoVisitante!,
                                                      ),
                                                      Text(
                                                        partida.nomeVisitante!,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                fatorDeEscalaMenor(
                                                                    20,
                                                                    context)),
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
                                                      vaipIA(
                                                          partida.nomeMandante,
                                                          partida
                                                              .nomeVisitante);
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
                                          height: fatorDeEscalaMenor(
                                              300 - 19, context),
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
                                  border:
                                      Border.all(color: Colors.green, width: 2),
                                  color: const Color.fromARGB(255, 17, 34, 23),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              width: fatorDeEscalaMenor(600, context),
                              child: Column(
                                children: [
                                  Text(
                                    "Jogadores em destaque",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            fatorDeEscalaMenor(30, context)),
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
                                                vaipjogador(jogador.id!);
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.green,
                                                radius: fatorDeEscalaMenor(
                                                    65, context),
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
                                                      fontSize:
                                                          fatorDeEscalaMenor(
                                                              25, context)),
                                                ),
                                                Text(
                                                  jogador.nomeTime!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          fatorDeEscalaMenor(
                                                              20, context)),
                                                ),
                                                Text(
                                                  "Desempenho: ${jogador.nota!.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          fatorDeEscalaMenor(
                                                              20, context)),
                                                ),
                                              ],
                                            )
                                          ]);
                                    }).toList(),
                                    options: CarouselOptions(
                                        height:
                                            fatorDeEscalaMenor(200, context),
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
                },
              );
            }
          },
        ));
  }

  Container navBarMobile(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            iconSize: fatorDeEscalaMobile(50, context),
            onPressed: () => setTipo("Times"),
            icon: Image.asset("assets/images/escudo.png",
                height: 50, color: Colors.white),
          ),
          IconButton(
            iconSize: fatorDeEscalaMobile(50, context),
            onPressed: () => setTipo("Jogadores"),
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
            onPressed: () => vaipIA(null, null),
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
          setTipo(value);
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
              setTipo("Times");
            }),
            _item("Jogadores", Icons.person, () {
              setTipo("Jogadores");
            }),
            _item("Comparações", Icons.person_search, () {
              setState(() {
                tipo = Tipos.pesquisaAvancada;
              });
            }),
            _item("Previsões IA", Icons.auto_awesome_rounded, () {
              vaipIA(null, null);
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
