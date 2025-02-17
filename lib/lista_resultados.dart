import 'package:flutter/material.dart';
import 'dart:math';

class ListaResultados extends StatefulWidget {
  final String pesquisa;
  const ListaResultados(this.pesquisa, {super.key});

  @override
  State<StatefulWidget> createState() => ListaResultadosState();
}

class ListaResultadosState extends State<ListaResultados> {
  @override
  Widget build(BuildContext context) {
    List results = [];
    for (int i = 0; i < Random().nextInt(50); i++) {
      if (Random().nextBool()) {
        results.add(_Jogador("Rodri", "Corinthians"));
      } else {
        results.add(_Time("Corinthians"));
      }
    }
    return GridView.count(
      crossAxisCount: 10,
      childAspectRatio: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.all(10),
      children: [for (int i = 0; i < results.length; i++) listEx(i, results)],
    );
  }

  Widget listEx(int indice, List results) {
    return GestureDetector(
      onTap: () {
        print("indice: $indice");
      },
      child: Container(
        color: results[indice] is _Jogador ? Colors.white : Colors.deepOrange,
        child: Row(children: [
          Image.network(
              "https://media.api-sports.io/football/players/5794.png"),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (results[indice] is _Jogador) ...[
                Text((results[indice] as _Jogador).nome),
                Text((results[indice] as _Jogador).time),
              ],
              if (results[indice] is _Time)
                Text((results[indice] as _Time).nome),
            ],
          )
        ]),
      ),
    );
  }
}

class _Jogador {
  late String nome;
  late String time;

  _Jogador(this.nome, this.time);
}

class _Time {
  late String nome;

  _Time(this.nome);
}
