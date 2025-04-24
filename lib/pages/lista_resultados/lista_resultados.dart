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
    return Container(
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: const Color.fromARGB(68, 34, 197, 94),
          border: Border.all(color: Colors.green)),
      child: Column(
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Resultado da pesquisa",
              style: TextStyle(color: Colors.white, fontSize: 50),
            )
          ]),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 3,
              mainAxisSpacing: 50,
              crossAxisSpacing: 10,
              children: [
                for (Time i in pesquisaRepository.times) listaTime(i),
                for (JogadorTime i in pesquisaRepository.jogadores)
                  listJogador(i)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget listaTime(Time time) {
    return GestureDetector(
      onTap: () {
        widget.onTeamClick(time.id ?? 131);
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
          child: CachedNetworkImage(
            imageUrl: time.logo!,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/error_image.png'),
          ),
        ),
        Text(
          time.nome ?? "Erro",
          style: const TextStyle(color: Colors.white),
        )
      ]),
    );
  }

  Widget listJogador(JogadorTime jogador) {
    return GestureDetector(
      onTap: () {
        widget.onPlayerClick(jogador.id ?? 5794);
      },
      child: Column(children: [
        Expanded(
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 65,
            child: CircleAvatar(
                radius: 60,
                backgroundImage: CachedNetworkImageProvider(jogador.image!)),
          ),
        ),
        Text(
          jogador.nome ?? "Carregando...",
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          jogador.nomeTime ?? "Carregando...",
          style: const TextStyle(color: Colors.white),
        ),
      ]),
    );
  }
}
