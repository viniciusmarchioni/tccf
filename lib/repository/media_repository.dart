import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MediaRepository {
  Medias medias = Medias();

  MediaRepository();

  Future<void> getMedia(String formacao) async {
    try {
      var response = await http
          .get(Uri.parse('http://localhost:5000/media/$formacao'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        medias = Medias.fromJsonAll(body);
      }
    } catch (e) {
      //
    }
  }
}

class Medias {
  double? assistencias;
  double? bloqueios;
  double? chutesNoGol;
  double? desarmes;
  double? driblesCompletos;
  double? duelos;
  double? gols;
  double? passesCertos;

  Medias();

  Medias.fromJsonAll(Map<String, dynamic> json)
      : assistencias = json['assistencias'],
        bloqueios = json['bloqueios'],
        chutesNoGol = json['chutes_no_gol'],
        desarmes = json['desarmes'],
        driblesCompletos = json['driblesCompletos'],
        duelos = json['duelos'],
        gols = json['gols'],
        passesCertos = json['passesCertos'];
}
