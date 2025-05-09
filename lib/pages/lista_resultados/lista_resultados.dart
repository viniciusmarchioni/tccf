import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scout/pages/estatisticas_jogador/estatisticas_jogador.dart';
import 'package:scout/pages/estatisticas_time/estatisticas_time.dart';
import 'package:scout/repository/pesquisarepository.dart';
import 'package:scout/util/util.dart';

class ListaResultados extends StatefulWidget {
  final String pesquisa;
  const ListaResultados(this.pesquisa, {super.key});

  @override
  State<StatefulWidget> createState() => ListaResultadosState();
}

class ListaResultadosState extends State<ListaResultados> {
  PesquisaRepository pesquisaRepository = PesquisaRepository();
  bool _isHovering = false;
  TextEditingController controller = TextEditingController();

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MouseRegion(
                onEnter: (event) => setState(() => _isHovering = true),
                onHover: (event) => setState(() => _isHovering = true),
                onExit: (event) => setState(() => _isHovering = false),
                child: GestureDetector(
                  child: Image.asset(
                    "assets/images/logo.png",
                    color: _isHovering ? Colors.green : Colors.white,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: fatorDeEscalaMenor(300, context),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ListaResultados(controller.text)),
                    );
                  },
                  controller: controller,
                ),
              ),
              OutlinedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(50, 0, 100, 55))),
                onPressed: () {},
                child: const Row(children: [
                  Icon(Icons.person_search, color: Colors.white),
                  Text(
                    "Estatisticas de jogadores",
                    style: TextStyle(color: Colors.white),
                  )
                ]),
              ),
            ],
          )),
      body: Container(
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
      ),
    );
  }

  Widget listaTime(Time time) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TimeEstatisticas(
                    idTime: time.id ?? 131,
                  )),
        );
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  JogadorEstatisticas(idJogador: jogador.id ?? 10007)),
        );
      },
      child: Column(children: [
        Expanded(
          child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 65,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: CachedNetworkImageProvider(jogador.image ?? "",
                    errorListener: (p0) =>
                        Image.asset('assets/images/error_image.png')),
              )),
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
