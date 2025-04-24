import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scout/repository/pesquisa_avancada_respository.dart';
import 'package:scout/util/util.dart';

class PesquisaAvancadaMobile extends StatefulWidget {
  final void Function(int) onPlayerClick;
  const PesquisaAvancadaMobile({super.key, required this.onPlayerClick});

  @override
  State<StatefulWidget> createState() => _PesquisaAvancadaState();
}

class _PesquisaAvancadaState extends State<PesquisaAvancadaMobile> {
  bool gols = false;
  TextEditingController controllerPosicao = TextEditingController();
  TextEditingController controllerFormacao = TextEditingController();
  PesquisaAvancadaRepository repository = PesquisaAvancadaRepository();
  Map<String, String> map = {
    "posicao": "",
    "formacao": "",
    "gols": "false",
    "desarmes": "false",
    "assistencias": "false",
    "passes-certos": "false",
    "passes-chaves": "false",
    "faltas-sofridas": "false",
    "dribles-completos": "false",
    "chutes-no-gol": "false",
    "bloqueados": "false",
  };

  final formacoes = [
    "Formação",
    "4-4-2",
    "4-3-3",
    "4-2-3-1",
    "3-4-1-2",
    "4-3-1-2",
    "4-1-3-2",
    "3-4-2-1",
    "3-5-2",
    "4-4-1-1",
    "5-4-1",
    "3-4-3",
    "4-3-2-1",
    "4-1-4-1",
    "5-3-2",
    "4-2-2-2",
    "4-5-1",
    "3-3-3-1",
    "3-3-1-3",
    "3-5-1-1",
    "3-2-4-1",
    "3-1-4-2",
  ];
  final posicoes = ["Posição", "Goleiro", "Defensor", "Meia", "Atacante"];
  String? dropDownValueForm = "Formação";
  String? dropDownValuePos = "Posição";
  bool carregando = false;

  void setDic(dynamic value, String key) {
    if (value == "Formação" || value == "Posição") {
      value = "";
    }

    setState(() {
      map[key] = value.toString();
    });

    pesquisa();
  }

  Future<void> pesquisa() async {
    setState(() {
      carregando = true;
    });
    await repository.pesquisa(map);
    setState(() {
      repository = repository;
      carregando = false;
    });
  }

  @override
  void initState() {
    super.initState();
    controllerPosicao.text = "Posição";
    controllerFormacao.text = "Formação";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.green)),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                dropdownColor: Colors.green,
                menuMaxHeight: 300,
                value: dropDownValuePos,
                items: [
                  for (var i in posicoes)
                    DropdownMenuItem(
                      value: i,
                      child: Text(i),
                    )
                ],
                onChanged: (value) {
                  setState(() {
                    dropDownValuePos = value;
                  });
                  setDic(value, "posicao");
                },
              )),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.green)),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                dropdownColor: Colors.green,
                menuMaxHeight: 300,
                value: dropDownValueForm,
                items: [
                  for (var i in formacoes)
                    DropdownMenuItem(
                      value: i,
                      child: Text(i),
                    )
                ],
                onChanged: (value) {
                  setState(() {
                    dropDownValueForm = value;
                  });
                  setDic(value, "formacao");
                },
              )),
            ),
            Container()
          ]),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Botao(onClick: setDic, texto: "gols"),
                _Botao(onClick: setDic, texto: "desarmes"),
                _Botao(onClick: setDic, texto: "assistencias"),
                _Botao(onClick: setDic, texto: "passes-certos"),
                _Botao(onClick: setDic, texto: "passes-chaves"),
                _Botao(onClick: setDic, texto: "faltas-sofridas"),
                _Botao(onClick: setDic, texto: "dribles-completos"),
                _Botao(onClick: setDic, texto: "chutes-no-gol"),
                _Botao(onClick: setDic, texto: "bloqueados"),
                _BotaoPe(
                  onClick: (p0) {},
                )
              ],
            ),
          )
        ]),
        const Divider(
          color: Colors.green,
        ),
        carregando
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var i in repository.resultados) cont(i, map)
                    ],
                  ),
                ),
              )
      ],
    );
  }

  Widget cont(Map<String, dynamic> map, Map<String, String> solicitacao) {
    Map<String, String> dic = {
      "gols": "Gols",
      "desarmes": "Desarmes",
      "assistencias": "Assistencias",
      "passes-certos": "Passes certos",
      "passes-chaves": "Chances criadas",
      "faltas-sofridas": "Faltas sofridas",
      "dribles-completos": "Dribles completos",
      "chutes-no-gol": "Chutes no gol",
      "bloqueados": "Bloqueios",
    };
    double nota = map.containsKey('nota') && map['nota'] is num
        ? (map['nota'] as num).toDouble()
        : 0.0;

    return GestureDetector(
      onTap: () {
        widget.onPlayerClick(map['id']);
      },
      child: Container(
        width: fatorDeEscalaMobile(300, context),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 17, 34, 23),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.green)),
        margin: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: fatorDeEscalaMobile(45, context),
            child: CircleAvatar(
                radius: fatorDeEscalaMobile(40, context),
                backgroundImage: CachedNetworkImageProvider(map['imagem']!)),
          ),
          Column(
            children: [
              Text(
                map['nome'] ?? 'erro',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMobile(15, context)),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                map['nomeTime'] ?? 'erro',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fatorDeEscalaMobile(15, context)),
                overflow: TextOverflow.ellipsis,
              ),
              for (var i in solicitacao.entries) ...[
                if (i.value == "true") ...[
                  Text(
                    "${dic[i.key]}: ${map[i.key]}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fatorDeEscalaMobile(15, context)),
                    overflow: TextOverflow.ellipsis,
                  )
                ]
              ]
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: fatorDeEscalaMobile(50, context),
              height: fatorDeEscalaMobile(50, context),
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(
                nota.toStringAsFixed(2),
                style: TextStyle(fontSize: fatorDeEscalaMobile(15, context)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Botao extends StatefulWidget {
  final void Function(bool, String) onClick;
  final String texto;

  const _Botao({required this.onClick, required this.texto});

  @override
  State<StatefulWidget> createState() => _BotaoState();
}

class _BotaoState extends State<_Botao> {
  // Dicionário dentro do estado do widget
  final dic = {
    "gols": "Gols",
    "desarmes": "Desarmes",
    "assistencias": "Assistencias",
    "passes-certos": "Passes certos",
    "passes-chaves": "Chances criadas",
    "faltas-sofridas": "Faltas sofridas",
    "dribles-completos": "Dribles completos",
    "chutes-no-gol": "Chutes no gol",
    "bloqueados": "Bloqueios",
  };

  bool ativo = false;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        margin:
            EdgeInsets.symmetric(horizontal: fatorDeEscalaMenor(10, context)),
        child: ativo
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  setState(() {
                    ativo = false;
                  });

                  widget.onClick(false, widget.texto);
                },
                child: Text(
                  dic[widget.texto] ?? widget.texto,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.green, width: 2),
                ),
                onPressed: () {
                  setState(() {
                    ativo = true;
                  });
                  widget.onClick(true, widget.texto);
                },
                child: Text(
                  dic[widget.texto] ?? widget.texto,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
      );
    });
  }
}

class _BotaoPe extends StatefulWidget {
  final void Function(String?) onClick;
  const _BotaoPe({required this.onClick});
  @override
  State<StatefulWidget> createState() => _BotaoPeState();
}

class _BotaoPeState extends State<_BotaoPe> {
  bool ativo = false;
  int index = 2;
  List<String> states = ["Destro", "Canhoto", "Pé preferido"];
  List<dynamic> values = ["Destro", "Canhoto", null];

  void aumentaIndice() {
    setState(() {
      if (index == 0) {
        ativo = true;
        index++;
      } else if (index == 1) {
        ativo = false;
        index++;
      } else {
        index = 0;
        ativo = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (ativo) {
        return ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green)),
            onPressed: () {
              aumentaIndice();
              widget.onClick(values[index]);
            },
            child: Text(states[index],
                style: const TextStyle(color: Colors.white)));
      }
      return OutlinedButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.black),
              side: MaterialStatePropertyAll(
                  BorderSide(color: Colors.green, width: 2))),
          onPressed: () {
            aumentaIndice();
            widget.onClick(values[index]);
          },
          child:
              Text(states[index], style: const TextStyle(color: Colors.green)));
    });
  }
}
