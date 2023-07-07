import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class Randomiser extends StatefulWidget {
  const Randomiser({super.key});

  @override
  State<Randomiser> createState() => _RandomiserState();
}

class _RandomiserState extends State<Randomiser> {
  TextEditingController listContoller = TextEditingController();
  bool buffer = true;
  int delay = 1;
  String displayText = 'Press Start';
  String currentItem = "";
  var range = Random();
  List<String> list = ["1", "4", "5", "6"];
  Timer? timer;

  String randomizerState = "Start";

  @override
  void dispose() {
    timer!.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Randomizer"),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text("Delay:"),
              ),
              NumberPicker(
                minValue: 1,
                maxValue: 5,
                onChanged: (value) {
                  delay = value;
                  setState(() {});
                },
                value: delay,
                axis: Axis.horizontal,
              )
            ],
          ),
          Text(
            displayText,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  height: 40,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      if (randomizerState == "Start") {
                        randomize();
                        randomizerState = "Stop";
                        setState(() {});
                      } else {
                        timer!.cancel();
                        randomizerState = "Start";
                        setState(() {});
                      }
                    },
                    child: Text(randomizerState),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  height: 40,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => customList(),
                      );
                    },
                    child: const Text("Custom List"),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  randomize() {
    timer = Timer.periodic(Duration(seconds: delay), (timer) {
      if (list.contains(currentItem)) {
        list.remove(currentItem);
        buffer = false;
      }
      int index = range.nextInt(list.length);
      displayText = list[index];
      setState(() {});
      if (!buffer) {
        list.add(currentItem);
      }
      currentItem = list[index];
    });
  }

  customList() {
    return AlertDialog(
      title: const Text("Custom List"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            createCustomList(listContoller.text);
            // listContoller.dispose();
            Navigator.pop(context);
          },
          child: const Text("Done"),
        ),
      ],
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            const Text("Enter custom list, Seperate items with a comma ',':"),
            const SizedBox(height: 10),
            TextField(
              controller: listContoller,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )
          ],
        ),
      ),
    );
  }

  void createCustomList(String text) {
    String item = "";
    List<String> customList = [];

    for (int i = 0; i < text.length; i++) {
      if (text[i] == ",") {
        customList.add(item);
        item = "";
        continue;
      }
      if (text[i] == " ") {
        if (i == text.length - 1) {
          customList.add(item);
          continue;
        }
        continue;
      }
      item += text[i];
      if (i == text.length - 1) {
        customList.add(item);
      }
    }

    print(text);
    print(customList);

    buffer = true;
    list = customList;
  }
}
