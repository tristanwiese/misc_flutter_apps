import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String? id;
  String? title;
  String? area;
  String? description;
  String? user;
  String? state;
  DateTime? date;

  set setData(QueryDocumentSnapshot<Map<String, dynamic>> report) {
    id = report.id;
    title = report["title"];
    area = report["area"];
    description = report["description"];
    user = report["user"];
    state = report["state"];
    date = report["date"].toDate();
  }
}
