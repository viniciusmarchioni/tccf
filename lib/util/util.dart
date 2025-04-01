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
