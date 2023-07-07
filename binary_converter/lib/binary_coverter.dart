import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Services/functions.dart';

class BinaryConverter extends StatefulWidget {
  const BinaryConverter({super.key});

  @override
  State<BinaryConverter> createState() => _BinaryConverterState();
}

class _BinaryConverterState extends State<BinaryConverter> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _messageController = TextEditingController();

  List<String> binary = [];

  bool convertBinary = false;

  String convertedBinary = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Binary Converter"),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [title(), inputText(), result()],
        ),
      ),
    );
  }

  Widget inputText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextFormField(
            controller: _messageController,
            decoration: InputDecoration(
                hintText: convertBinary ? "Binary" : "Message",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                !convertBinary
                    ? setState(() {
                        binary =
                            messageToBinary(_messageController.text.trim());
                      })
                    : setState(() {
                        convertedBinary =
                            binaryToString(_messageController.text.trim());
                      });
              },
              child: const Text("Convert"),
            ),
            Switch(
              value: convertBinary,
              onChanged: (value) {
                setState(() {
                  _messageController.clear();
                  convertBinary = value;
                });
              },
            )
          ],
        )
      ],
    );
  }

  Widget result() {
    return Column(
      children: [
        ResultText(
            boilderPlate: convertBinary ? "Your Binary" : "Your message",
            customText: _messageController.text.trim()),
        const SizedBox(height: 10),
        ResultText(
            boilderPlate:
                convertBinary ? "Binary To Message" : "Message to Binary",
            customText:
                convertBinary ? convertedBinary : trim(binary.toString())),
        const SizedBox(height: 10),
        binary.isNotEmpty
            ? SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: trim(binary.toString())));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text("Copy"),
                ),
              )
            : Container()
      ],
    );
  }

  Widget title() {
    return const Text(
      "Enter message and press convert",
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
    );
  }
}

class ResultText extends StatelessWidget {
  const ResultText(
      {super.key, required this.boilderPlate, required this.customText});

  final String boilderPlate;
  final String customText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$boilderPlate:",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            customText,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
