import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scout/repository/menu_repository.dart';
import 'package:scout/util/util.dart';

class MenuMobile extends StatefulWidget {
  final void Function(int) onPlayerClick;
  final void Function(int) onTimeClick;
  final void Function(String? mandante, String? visitante) vaipIA;
  const MenuMobile(
      {super.key,
      required this.onPlayerClick,
      required this.onTimeClick,
      required this.vaipIA});

  @override
  State<StatefulWidget> createState() => _MenuMobileState();
}

class _MenuMobileState extends State<MenuMobile> {
  MenuRepository menuRepository = MenuRepository();

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    await menuRepository.init();

    setState(() {
      menuRepository = menuRepository;
    });
  }

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
  Widget build(BuildContext context) {
    return menuMobile(context);
  }

  Widget menuMobile(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              //padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  color: const Color.fromARGB(255, 17, 34, 23),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Text(
                    "Próximos jogos",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fatorDeEscalaMobile(30, context)),
                  ),
                  CarouselSlider(
                    carouselController: CarouselSliderController(),
                    items: menuRepository.ultimasPartidas.map((partida) {
                      return Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Mandante
                                GestureDetector(
                                  onTap: () {
                                    widget.onTimeClick(partida.idMandante!);
                                  },
                                  child: Column(children: [
                                    Image.network(
                                      partida.logoMandante!,
                                      height: fatorDeEscalaMobile(100, context),
                                      width: fatorDeEscalaMobile(100, context),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        partida.nomeMandante!,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMobile(
                                                20, context)),
                                      ),
                                    )
                                  ]),
                                ),
                                //Data do jogo
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${partida.data?.hour}:${partida.data?.minute}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMobile(
                                                20, context)),
                                      ),
                                      Text(
                                        dic[partida.data?.weekday].toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMobile(
                                                20, context)),
                                      ),
                                      Text(
                                        "${partida.data?.day}/${partida.data?.month}/${(partida.data?.year ?? 0) - 2000}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMobile(
                                                20, context)),
                                      )
                                    ]),
                                //Visitante
                                GestureDetector(
                                  onTap: () {
                                    widget.onTimeClick(partida.idVisitante!);
                                  },
                                  child: Column(children: [
                                    Image.network(
                                      height: fatorDeEscalaMobile(100, context),
                                      width: fatorDeEscalaMobile(100, context),
                                      partida.logoVisitante!,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        partida.nomeVisitante!,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fatorDeEscalaMobile(
                                                20, context)),
                                      ),
                                    )
                                  ]),
                                )
                              ]),
                          //Botão prever
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.green)),
                                    onPressed: () {
                                      widget.vaipIA(partida.nomeMandante,
                                          partida.nomeVisitante);
                                    },
                                    child: Text(
                                      "Prever",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              fatorDeEscalaMobile(20, context)),
                                    ))
                              ],
                            ),
                          )
                        ],
                      );
                    }).toList(),
                    options: CarouselOptions(
                        viewportFraction: 1,
                        animateToClosest: true,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlay: true),
                  )
                ],
              ),
            ),
            //Carrossel jogadores em destaque
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  color: const Color.fromARGB(255, 17, 34, 23),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              width: fatorDeEscalaMobile(600, context),
              child: Column(
                children: [
                  Text(
                    "Jogadores em destaque",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fatorDeEscalaMobile(30, context)),
                  ),
                  CarouselSlider(
                    items: menuRepository.jogadoresDestaque.map((jogador) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.onPlayerClick(jogador.id!);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: fatorDeEscalaMobile(65, context),
                                child: CircleAvatar(
                                    radius: fatorDeEscalaMobile(60, context),
                                    backgroundImage: CachedNetworkImageProvider(
                                        jogador.imagem!)),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: fatorDeEscalaMobile(150, context),
                                  child: Text(
                                    jogador.nome!,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            fatorDeEscalaMobile(25, context)),
                                  ),
                                ),
                                Text(
                                  jogador.nomeTime!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMobile(20, context)),
                                ),
                                Text(
                                  "Desempenho: ${jogador.nota!.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          fatorDeEscalaMobile(20, context)),
                                ),
                              ],
                            )
                          ]);
                    }).toList(),
                    options: CarouselOptions(
                        viewportFraction: 1,
                        animateToClosest: true,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlay: true),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(child: ultimosJogosMobile(context)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container ultimosJogosMobile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 17, 34, 23),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.green)),
      padding: EdgeInsets.all(fatorDeEscalaMobile(15, context)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("Últimos jogos",
            style: TextStyle(
                color: Colors.white,
                fontSize: fatorDeEscalaMobile(30, context))),
        Column(
          children: [for (var i in menuRepository.ultimasPartidas) jogo(i)],
        )
      ]),
    );
  }

  Widget jogo(Partida partida) {
    const tamanhoTime = 40.0;
    const tamanhoFonteDia = 15.0;
    const tamanhoFonteTime = 20.0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: fatorDeEscalaMobile(10, context)),
      child: Column(children: [
        Text(
          "${partida.data?.hour}:${partida.data?.minute}-${dic[partida.data?.weekday]}-${partida.data?.day}/${partida.data?.month}",
          style: TextStyle(
              color: Colors.white,
              fontSize: fatorDeEscalaMobile(tamanhoFonteDia, context)),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: fatorDeEscalaMobile(100, context),
              child: Text(
                partida.nomeMandante ?? "...",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMobile(tamanhoFonteTime, context)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            CachedNetworkImage(
              width: fatorDeEscalaMobile(tamanhoTime, context),
              imageUrl: partida.logoMandante!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/error_image.png'),
            ),
            Text(
              partida.golsMandante.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMobile(tamanhoFonteTime, context)),
            ),
            Image.asset("assets/images/vs.png",
                height: fatorDeEscalaMobile(tamanhoFonteTime, context)),
            Text(
              partida.golsVisitante.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fatorDeEscalaMobile(tamanhoFonteTime, context)),
            ),
            CachedNetworkImage(
              width: fatorDeEscalaMobile(tamanhoTime, context),
              imageUrl: partida.logoVisitante!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/error_image.png'),
            ),
            SizedBox(
              width: fatorDeEscalaMobile(100, context),
              child: Text(partida.nomeVisitante ?? "...",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          fatorDeEscalaMobile(tamanhoFonteTime, context))),
            )
          ],
        )
      ]),
    );
  }
}
