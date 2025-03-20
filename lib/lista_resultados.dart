import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scout/repository/pesquisarepository.dart';

class ListaResultados extends StatefulWidget {
  final String pesquisa;
  final void Function(int) onTeamClick;
  final void Function(int) onPlayerClick;
  const ListaResultados(this.pesquisa,
      {super.key, required this.onTeamClick, required this.onPlayerClick});

  @override
  State<StatefulWidget> createState() => ListaResultadosState();
}

class ListaResultadosState extends State<ListaResultados> {
  PesquisaRepository pesquisaRepository = PesquisaRepository();

  Future<void> _carregaPesquisa(String pesquisa) async {
    await pesquisaRepository.pesquisa(pesquisa);
    setState(() {
      pesquisaRepository = pesquisaRepository;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregaPesquisa(widget.pesquisa);
  }

  @override
  void didUpdateWidget(covariant ListaResultados oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pesquisa != widget.pesquisa) {
      _carregaPesquisa(widget.pesquisa);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 10,
      childAspectRatio: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.all(10),
      children: [
        for (Time i in pesquisaRepository.times) listEx(i),
        for (JogadorTime i in pesquisaRepository.jogadores) listJogador(i)
      ],
    );
  }

  Widget listEx(Time time) {
    return GestureDetector(
      onTap: () {
        //print("indice: $indice");
      },
      child: Container(
        color: Colors.deepOrange,
        child: GestureDetector(
          onTap: () {
            widget.onTeamClick(time.id ?? 131);
          },
          child: Row(children: [
            CachedNetworkImage(
              imageUrl: time.logo!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/error_image.png'),
            ),
            Expanded(
                child:
                    Text(time.nome ?? 'Erro', overflow: TextOverflow.ellipsis)),
          ]),
        ),
      ),
    );
  }

  Widget listJogador(JogadorTime jogador) {
    return GestureDetector(
      onTap: () {
        //print("indice: $indice");
      },
      child: Container(
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            widget.onPlayerClick(jogador.id ?? 5794);
          },
          child: Row(children: [
            CachedNetworkImage(
              imageUrl: jogador.image!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/error_image.png'),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(jogador.nome ?? 'Erro', overflow: TextOverflow.ellipsis),
                Text(jogador.nomeTime ?? '', overflow: TextOverflow.ellipsis)
              ],
            )),
          ]),
        ),
      ),
    );
  }
}
