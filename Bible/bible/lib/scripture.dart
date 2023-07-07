// ignore_for_file: constant_identifier_names, avoid_print
import 'package:bible/scripture_model.dart';
import 'package:http/http.dart' as http;


class Scripture {
  Scripture({
    required this.book,
    required this.chapter,
    required this.verse,
    // required this.scripture,
  });

  String url = "https://bible-api.com/";

  final String book;
  final String chapter;
  final String verse;
  late String scripture;

  Future<dynamic> getScripture() async {
    Uri uri;
    if (verse == "") {
      uri = Uri.parse("$url$book$chapter");
    } else {
      uri = Uri.parse("$url$book$chapter:$verse");
    }
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = response.body;
      return scriptureModelFromJson(json);
    } else {
      return "Not Found";
    }
  }
}
