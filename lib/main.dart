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
  Tipos? tipo = Tipos.time;
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
      controller.clear();
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
        backgroundColor: Colors.blue.shade400,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade400,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    tipo = Tipos.ia;
                  });
                },
                child: const Icon(Icons.auto_awesome_sharp),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  onSubmitted: (value) {
                    setTipo(value);
                  },
                  controller: controller,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isEmpty) {
                    return;
                  }
                  setTipo(controller.text);
                },
                child: const Icon(Icons.search),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    tipo = Tipos.pesquisaAvancada;
                  });
                },
                child: const Icon(Icons.person_search_rounded),
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
