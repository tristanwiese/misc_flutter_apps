import 'package:bible/scripture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Bible extends StatefulWidget {
  const Bible({super.key});

  @override
  State<Bible> createState() => _BibleState();
}

class _BibleState extends State<Bible> {
  bool load = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _bookController = TextEditingController();
  final TextEditingController _chapterController = TextEditingController();
  final TextEditingController _verseController = TextEditingController();

  dynamic scripture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Bible",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
                  SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _bookController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: "Book"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _chapterController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: "Chapter"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _verseController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: "Verse"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            scripture = null;
                            load = true;
                          });
                          scripture = await Scripture(
                            book: _bookController.text.trim(),
                            chapter: _chapterController.text.trim(),
                            verse: _verseController.text.trim(),
                          ).getScripture();
                          setState(() {
                            load = false;
                          });
                        }
                      },
                      child: const Text("Find verse")),
                  const SizedBox(height: 20),
                  (scripture != null)
                      ? Container(
                          constraints:
                              const BoxConstraints(maxWidth: 400, maxHeight: 500),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              color: Colors.deepPurple[100],
                              borderRadius: BorderRadius.circular(20)),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Verse:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  (scripture != null)
                                      ? (scripture == "Not Found")
                                          ? Text(scripture)
                                          : Text(scripture.text)
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        )
                      : load
                          ? const CircularProgressIndicator()
                          : Container(),
                  const SizedBox(height: 10),
                  (scripture != null && scripture != "Not Found")
                      ? ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: scripture.text));
                          },
                          child: const Text("Copy"),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
