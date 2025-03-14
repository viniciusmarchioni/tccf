import 'package:flutter/material.dart';
import 'package:scout/estatisticas_jogador.dart';
import 'package:scout/estatisticas_time.dart';
import 'package:scout/lista_resultados.dart';
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
  Tipos? tipo = Tipos.jogador;
  int idTime = 131; // ID Corinthians
  int idJogador = 5794; // ID Garro

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
      if (str == "Corinthians") {
        tipo = Tipos.time;
      } else if (str == "Coronado") {
        tipo = Tipos.jogador;
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
                  setTipo(controller.text);
                },
                child: const Icon(Icons.search),
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
                  controller.text,
                  onTeamClick: vaiptime,
                  onPlayerClick: vaipjogador,
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
