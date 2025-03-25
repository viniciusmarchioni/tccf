import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scout/repository/pesquisa_avancada_respository.dart';

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

  bool carregando = false;

  void setDic(dynamic value, String key) {
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
      backgroundColor: Colors.blue.shade400,
      appBar: AppBar(
          backgroundColor: Colors.blue.shade400,
          flexibleSpace: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DropdownMenu(
                    requestFocusOnTap: false,
                    controller: controllerPosicao,
                    onSelected: (value) {
                      setDic(value, "posicao");
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: "", label: "Posição"),
                      DropdownMenuEntry(value: "G", label: "Goleiro"),
                      DropdownMenuEntry(value: "D", label: "Defensor"),
                      DropdownMenuEntry(value: "M", label: "Meia"),
                      DropdownMenuEntry(value: "F", label: "Atacante"),
                    ],
                  ),
                  DropdownMenu(
                    requestFocusOnTap: false,
                    onSelected: (value) {
                      setDic(value, "formacao");
                    },
                    controller: controllerFormacao,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: "", label: "Formação"),
                      DropdownMenuEntry(value: "4-4-2", label: "4-4-2"),
                      DropdownMenuEntry(value: "4-3-3", label: "4-3-3"),
                      DropdownMenuEntry(value: "4-2-3-1", label: "4-2-3-1"),
                      DropdownMenuEntry(value: "3-4-1-2", label: "3-4-1-2"),
                      DropdownMenuEntry(value: "3-4-1-2", label: "3-4-1-2"),
                      DropdownMenuEntry(value: "4-3-1-2", label: "4-3-1-2"),
                      DropdownMenuEntry(value: "4-1-3-2", label: "4-1-3-2"),
                      DropdownMenuEntry(value: "3-4-2-1", label: "3-4-2-1"),
                      DropdownMenuEntry(value: "3-5-2", label: "3-5-2"),
                      DropdownMenuEntry(value: "4-4-1-1", label: "4-4-1-1"),
                      DropdownMenuEntry(value: "5-4-1", label: "5-4-1"),
                      DropdownMenuEntry(value: "3-4-3", label: "3-4-3"),
                      DropdownMenuEntry(value: "4-3-2-1", label: "4-3-2-1"),
                      DropdownMenuEntry(value: "4-1-4-1", label: "4-1-4-1"),
                      DropdownMenuEntry(value: "5-3-2", label: "5-3-2"),
                      DropdownMenuEntry(value: "4-2-2-2", label: "4-2-2-2"),
                      DropdownMenuEntry(value: "4-5-1", label: "4-5-1"),
                      DropdownMenuEntry(value: "3-3-3-1", label: "3-3-3-1"),
                      DropdownMenuEntry(value: "3-3-1-3", label: "3-3-1-3"),
                      DropdownMenuEntry(value: "3-5-1-1", label: "3-5-1-1"),
                      DropdownMenuEntry(value: "3-2-4-1", label: "3-2-4-1"),
                      DropdownMenuEntry(value: "3-1-4-2", label: "3-1-4-2"),
                    ],
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
    return ElevatedButton(
        style: ativo
            ? const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white))
            : const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue)),
        onPressed: () {
          setState(() {
            ativo = !ativo;
          });
          widget.onClick(ativo, widget.texto);
        },
        child: Text(dic[widget.texto] ?? widget.texto));
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
                backgroundColor: MaterialStatePropertyAll(Colors.white))
            : const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue)),
        onPressed: () {
          aumentaIndice();
          widget.onClick(values[index]);
        },
        child: index < 2 ? Text(states[index]) : const Text("Pé preferido"));
  }
}
