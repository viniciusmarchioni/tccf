import 'package:flutter/material.dart';

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
