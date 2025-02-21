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
  Tipos? tipo = Tipos.time;
  String pesquisabox = "";
  String formation = "4-1-2-1-2";
  int idTime = 131;

  void vaiptime(int id) {
    setState(() {
      idTime = id;
      tipo = Tipos.time;
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
              return const JogadorEstatisticas();
            } else if (tipo == Tipos.pesquisa) {
              return Center(
                child: ListaResultados(controller.text, fun: vaiptime),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}

class _Teste extends StatefulWidget {
  final String str;
  const _Teste(this.str);

  @override
  State<StatefulWidget> createState() => _TesteState();
}

class _TesteState extends State<_Teste> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.str),
    );
  }
}

/*Builder(
          builder: (context) {
            if (tipo == Tipos.time) {
              return const TimeEstatisticas();
            } else if (tipo == Tipos.jogador) {
              return const JogadorEstatisticas();
            } else if (tipo == Tipos.pesquisa) {
              return Center(
                child: ListaResultados(controller.text),
              );
            } else {
              return Container();
            }
          },
        ));*/