import 'package:flutter/material.dart';

class JogadorEstatisticas extends StatefulWidget {
  const JogadorEstatisticas({super.key});

  @override
  State<StatefulWidget> createState() => _JogadorEstatisticaState();
}

class _JogadorEstatisticaState extends State {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(158, 134, 132, 131),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.all(50),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Container(
            color: Colors.amber,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(25),
            child: const Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://media.api-sports.io/football/players/5794.png"),
                  radius: 150,
                ),
                Text(
                  "Rodrigo Garro",
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  "Corinthians",
                  style: TextStyle(fontSize: 20),
                ),
                DropdownMenu(
                  hintText: "Formação",
                  requestFocusOnTap: false,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "4-4-2", label: "4-4-2"),
                    DropdownMenuEntry(value: "4-1-2-1-2", label: "4-1-2-1-2"),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.blueAccent,
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  containerNota(),
                  /*
                  const ListaPros(
                    formacao: "",
                  ),*/
                  Container()
                ],
              )
            ]),
          ),
        )
      ]),
    );
  }

  Widget containerNota() {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      color: Colors.green,
      child: const Text("1"),
    );
  }
}
