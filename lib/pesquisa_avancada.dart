import 'package:flutter/material.dart';

class PesquisaAvancada extends StatefulWidget {
  const PesquisaAvancada({super.key});

  @override
  State<StatefulWidget> createState() => _PesquisaAvancadaState();
}

class _PesquisaAvancadaState extends State<PesquisaAvancada> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade400,
      appBar: AppBar(
          backgroundColor: Colors.blue.shade400,
          flexibleSpace: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "", label: "")
                  ],
                ),
                DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "", label: "")
                  ],
                ),
                DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "", label: "")
                  ],
                ),
                DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "", label: "")
                  ],
                ),
                DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "", label: "")
                  ],
                ),
                DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "", label: "")
                  ],
                ),
              ],
            ),
          )),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [for (int i = 0; i < 100; i++) cont()],
        )),
      ),
    );
  }

  Widget cont() {
    return Container(
      width: 300,
      height: 100,
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child: const Center(child: Text("data")),
    );
  }
}
