import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PesquisaRepository {
  List<Time> times = [];

  PesquisaRepository();

  Future<void> pesquisa(String pesquisa) async {
    try {
      var response = await http
          .get(Uri.parse('http://localhost:5000/$pesquisa'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        times = [];
        var body = jsonDecode(response.body)['times'];

        for (var i in body) {
          times.add(Time.fromJsonAll(i));
        }
      }
    } catch (e) {
      //
    }
  }
}

class Time {
  int? id;
  String? nome;

  Time();

  Time.fromJsonAll(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'];
}
