import 'package:flutter/material.dart';

//const String endereco = "https://corinthianspaulista1910.duckdns.org";
const String endereco = "http://localhost:5000/";

double fatorDeEscalaMaior(double valorBom, BuildContext context) {
  double fatorDeEscala = 0;
  if (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) {
    fatorDeEscala = valorBom / 1920;
  } else {
    fatorDeEscala = valorBom / 945;
  }
  return MediaQuery.of(context).size.shortestSide * fatorDeEscala;
}

double fatorDeEscalaMenor(double valorBom, BuildContext context) {
  double fatorDeEscala = 0;
  if (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) {
    fatorDeEscala = valorBom / 1920;
  } else {
    fatorDeEscala = valorBom / 945;
  }
  return MediaQuery.of(context).size.shortestSide * fatorDeEscala;
}

double fatorDeEscalaMenorReverso(double valorBom, BuildContext context) {
  double fatorDeEscala;
  if (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) {
    fatorDeEscala = 1920 / valorBom; // Inverter a relação
  } else {
    fatorDeEscala = 945 / valorBom;
  }
  return fatorDeEscala / MediaQuery.of(context).size.shortestSide;
}

double fatorDeEscalaMobile(double valorBom, BuildContext context) {
  double fatorDeEscala = 0;
  if (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) {
    fatorDeEscala = valorBom / 412;
  } else {
    fatorDeEscala = valorBom / 915;
  }
  return MediaQuery.of(context).size.shortestSide * fatorDeEscala;
}

SizedBox pesquisaMobile(BuildContext context) {
  return SizedBox(
    width: fatorDeEscalaMobile(300, context),
    child: TextField(
      decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.white)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.white)),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          hintText: "Pesquise no Scout AI"),
      onSubmitted: (value) {},
    ),
  );
}
