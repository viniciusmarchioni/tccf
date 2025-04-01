import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scout/repository/pesquisa_avancada_respository.dart';
import 'package:scout/util/util.dart';

class PesquisaAvancada extends StatefulWidget {
  final void Function(int) onPlayerClick;
  const PesquisaAvancada({super.key, required this.onPlayerClick});

  @override
  State<StatefulWidget> createState() => _PesquisaAvancadaState();
}

class _PesquisaAvancadaState extends State<PesquisaAvancada> {
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
    "passes_certos": "false",
    "passes_chaves": "false",
    "faltas_sofridas": "false",
    "dribles_completos": "false",
    "chutes_no_gol": "false",
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          flexibleSpace: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: fatorDeEscalaMenor(10, context)),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.green)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton(
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
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: fatorDeEscalaMenor(10, context)),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.green)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton(
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
                _Botao(onClick: setDic, texto: "gols"),
                _Botao(onClick: setDic, texto: "desarmes"),
                _Botao(onClick: setDic, texto: "assistencias"),
                _Botao(onClick: setDic, texto: "passes_certos"),
                _Botao(onClick: setDic, texto: "chances_criadas"),
                _Botao(onClick: setDic, texto: "faltas_sofridas"),
                _Botao(onClick: setDic, texto: "dribles_completos"),
                _Botao(onClick: setDic, texto: "chutes_no_gol"),
                _Botao(onClick: setDic, texto: "bloqueados"),
                _BotaoPe(
                  onClick: (p0) {},
                )
              ],
            ),
          )),
      body: !carregando
          ? Center(
              child: SingleChildScrollView(
                  child: Column(
                children: [for (var i in repository.resultados) cont(i, map)],
              )),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget cont(Map<String, dynamic> map, Map<String, String> solicitacao) {
    Map<String, String> dic = {
      "gols": "Gols",
      "desarmes": "Desarmes",
      "assistencias": "Assistencias",
      "passes_certos": "Passes certos",
      "chances_criadas": "Chances criadas",
      "faltas_sofridas": "Faltas sofridas",
      "dribles_completos": "Dribles completos",
      "chutes_no_gol": "Chutes no gol",
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
        width: 300,
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CachedNetworkImage(
            imageUrl: map['imagem'],
            height: 100,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/error_image.png'),
          ),
          Column(
            children: [
              Text(map['nome'] ?? 'erro'),
              Text(map['nomeTime'] ?? 'erro'),
              for (var i in solicitacao.entries) ...[
                if (i.value == "true") ...[Text("${dic[i.key]}: ${map[i.key]}")]
              ]
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(nota.toStringAsFixed(2)),
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
  Map<String, String> dic = {
    "gols": "Gols",
    "desarmes": "Desarmes",
    "assistencias": "Assistencias",
    "passes_certos": "Passes certos",
    "chances_criadas": "Chances criadas",
    "faltas_sofridas": "Faltas sofridas",
    "dribles_completos": "Dribles completos",
    "chutes_no_gol": "Chutes no gol",
    "bloqueados": "Bloqueios",
  };
  bool ativo = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: fatorDeEscalaMenor(10, context)),
      child: ElevatedButton(
          style: ativo
              ? const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green))
              : const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 40, 92, 42))),
          onPressed: () {
            setState(() {
              ativo = !ativo;
            });
            widget.onClick(ativo, widget.texto);
          },
          child: Text(
            dic[widget.texto] ?? widget.texto,
            style: const TextStyle(color: Colors.black),
          )),
    );
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
    return ElevatedButton(
        style: ativo
            ? const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green))
            : const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Color.fromARGB(255, 40, 92, 42))),
        onPressed: () {
          aumentaIndice();
          widget.onClick(values[index]);
        },
        child: index < 2
            ? Text(states[index], style: const TextStyle(color: Colors.black))
            : const Text("Pé preferido",
                style: TextStyle(color: Colors.black)));
  }
}
