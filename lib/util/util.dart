import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      onSubmitted: (value) {
        context.push("/pesquisa/$value");
      },
    ),
  );
}

AppBar modeloAppBarMobile(BuildContext context) {
  return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          GestureDetector(
            child: Image.asset(
              "assets/images/logo.png",
              scale: fatorDeEscalaMenorReverso(1, context),
            ),
            onTap: () {
              context.push("/");
            },
          ),
          Container(),
        ],
      ));
}

Container navBarMobile(BuildContext context) {
  return Container(
    color: Colors.black,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          iconSize: fatorDeEscalaMobile(50, context),
          onPressed: () {
            context.push("/pesquisa/Times");
          },
          icon: Image.asset("assets/images/escudo.png",
              height: 50, color: Colors.white),
        ),
        IconButton(
          iconSize: fatorDeEscalaMobile(50, context),
          onPressed: () {
            context.push("/pesquisa/Jogadores");
          },
          color: Colors.white,
          icon: const Icon(Icons.person),
        ),
        IconButton(
          iconSize: fatorDeEscalaMobile(50, context),
          onPressed: () {
            context.push("/Ia");
          },
          color: Colors.white,
          icon: const Icon(Icons.auto_awesome_rounded),
        ),
      ],
    ),
  );
}
