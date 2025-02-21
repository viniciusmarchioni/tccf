import 'package:flutter/material.dart';
import 'package:scout/repository/pesquisarepository.dart';

class ListaResultados extends StatefulWidget {
  final String pesquisa;
  final void Function(int) fun;
  const ListaResultados(this.pesquisa, {super.key, required this.fun});

  @override
  State<StatefulWidget> createState() => ListaResultadosState();
}

class ListaResultadosState extends State<ListaResultados> {
  PesquisaRepository pesquisaRepository = PesquisaRepository();

  Future<void> _carregaPesquisa(String pesquisa) async {
    await pesquisaRepository.pesquisa(pesquisa);
    setState(() {
      pesquisaRepository.times = pesquisaRepository.times;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregaPesquisa(widget.pesquisa);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 10,
      childAspectRatio: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.all(10),
      children: [for (Time i in pesquisaRepository.times) listEx(i)],
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
            widget.fun(time.id ?? 131);
          },
          child: Row(children: [
            Image.network(
                "https://media.api-sports.io/football/players/5794.png"),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(time.nome ?? 'Erro', overflow: TextOverflow.ellipsis),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
