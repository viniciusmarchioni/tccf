import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PesquisaRepository {
  List<Times> times = [];

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
          times.add(Times.fromJsonAll(i));
        }
      }
    } catch (e) {
      //
    }
  }
}

class Times {
  int? id;
  String? nome;

  Times();

  Times.fromJsonAll(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'];
}
