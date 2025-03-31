import 'package:flutter/material.dart';
import 'package:scout/estatisticas_jogador.dart';
import 'package:scout/estatisticas_time.dart';
import 'package:scout/ia.dart';
import 'package:scout/lista_resultados.dart';
import 'package:scout/pesquisa_avancada.dart';
import 'package:scout/util/tipos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scoutcc',
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
  Tipos? tipo = Tipos.pesquisa;
  int idTime = 131; // ID Corinthians
  int idJogador = 10007; // ID Yuri
  String pesquisa = "Cor";

  void vaiptime(int id) {
    setState(() {
      idTime = id;
      tipo = Tipos.time;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Logo",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 300,
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
              return Center(
                child: ListaResultados(
                  pesquisa,
                  onTeamClick: vaiptime,
                  onPlayerClick: vaipjogador,
                ),
              );
            } else if (tipo == Tipos.pesquisaAvancada) {
              return PesquisaAvancada(
                onPlayerClick: vaipjogador,
              );
            } else if (tipo == Tipos.ia) {
              return const Ia();
            } else {
              return Container();
            }
          },
        ));
  }
}
