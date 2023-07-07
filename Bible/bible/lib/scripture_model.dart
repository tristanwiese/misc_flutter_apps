// To parse this JSON data, do
//
//     final scriptureModel = scriptureModelFromJson(jsonString);

import 'dart:convert';

ScriptureModel scriptureModelFromJson(String str) => ScriptureModel.fromJson(json.decode(str));

String scriptureModelToJson(ScriptureModel data) => json.encode(data.toJson());

class ScriptureModel {
    String reference;
    List<Verse> verses;
    String text;
    String translationId;
    String translationName;
    String translationNote;

    ScriptureModel({
        required this.reference,
        required this.verses,
        required this.text,
        required this.translationId,
        required this.translationName,
        required this.translationNote,
    });

    factory ScriptureModel.fromJson(Map<String, dynamic> json) => ScriptureModel(
        reference: json["reference"],
        verses: List<Verse>.from(json["verses"].map((x) => Verse.fromJson(x))),
        text: json["text"],
        translationId: json["translation_id"],
        translationName: json["translation_name"],
        translationNote: json["translation_note"],
    );

    Map<String, dynamic> toJson() => {
        "reference": reference,
        "verses": List<dynamic>.from(verses.map((x) => x.toJson())),
        "text": text,
        "translation_id": translationId,
        "translation_name": translationName,
        "translation_note": translationNote,
    };
}

class Verse {
    String bookId;
    String bookName;
    int chapter;
    int verse;
    String text;

    Verse({
        required this.bookId,
        required this.bookName,
        required this.chapter,
        required this.verse,
        required this.text,
    });

    factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        bookId: json["book_id"],
        bookName: json["book_name"],
        chapter: json["chapter"],
        verse: json["verse"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "book_id": bookId,
        "book_name": bookName,
        "chapter": chapter,
        "verse": verse,
        "text": text,
    };
}
