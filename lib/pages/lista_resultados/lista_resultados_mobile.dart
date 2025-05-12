import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scout/repository/pesquisarepository.dart';
import 'package:scout/util/util.dart';

class ListaResultadosMobile extends StatefulWidget {
  final String pesquisa;
  const ListaResultadosMobile(this.pesquisa, {super.key});

  @override
  State<StatefulWidget> createState() => ListaResultadosState();
}

class ListaResultadosState extends State<ListaResultadosMobile> {
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
  void didUpdateWidget(covariant ListaResultadosMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pesquisa != widget.pesquisa) {
      _carregaPesquisa(widget.pesquisa);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: modeloAppBarMobile(context),
      body: Column(
        children: [
          pesquisaMobile(context),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(68, 34, 197, 94),
                  border: Border.all(color: Colors.green)),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Resultado da pesquisa",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: fatorDeEscalaMobile(25, context)),
                    )
                  ]),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: double.infinity),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (Time i in pesquisaRepository.times)
                              listaTime(i),
                            for (JogadorTime j in pesquisaRepository.jogadores)
                              listaJogador(j),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          navBarMobile(context)
        ],
      ),
    );
  }

  Widget listaTime(Time time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          context.push('/times/${time.id}');
        },
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CachedNetworkImage(
            height: fatorDeEscalaMobile(100, context),
            imageUrl: time.logo!,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/error_image.png'),
          ),
          Text(
            time.nome ?? "Erro",
            style: const TextStyle(color: Colors.white),
          )
        ]),
      ),
    );
  }

  Widget listaJogador(JogadorTime jogador) {
    return GestureDetector(
      onTap: () {
        context.push('/jogadores/${jogador.id}');
      },
      child: Column(children: [
        CircleAvatar(
          backgroundColor: Colors.green,
          radius: fatorDeEscalaMobile(55, context),
          child: CircleAvatar(
              radius: fatorDeEscalaMobile(50, context),
              backgroundImage: CachedNetworkImageProvider(
                jogador.image ?? "",
                errorListener: (p0) =>
                    Image.asset('assets/images/error_image.png'),
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
