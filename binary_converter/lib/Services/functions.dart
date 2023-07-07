List<int> binaryScope7bit = [64, 32, 16, 8, 4, 2, 1];
List<int> binaryScope8bit = [128, 64, 32, 16, 8, 4, 2, 1];

String trim(
  String string,
) {
  String newString = '';

  for (int i = 0; i < string.length; i++) {
    if (string[i] == "[" || string[i] == "]" || string[i] == ",") {
      continue;
    }
    newString += string[i];
  }
  return newString;
}

List<String> messageToBinary(String text) {
  String message = text;

  List<int> asciiValues = [];

  for (int i = 0; i < message.length; i++) {
    int ascii = message.codeUnitAt(i);
    asciiValues.add(ascii);
  }

  return asciiToBinary(asciiValues: asciiValues);
}

List<String> asciiToBinary({required List<int> asciiValues}) {
  String binaryLetter = "";

  List<String> binaryScentence = [];

  for (int ascii in asciiValues) {
    for (int binaryDevider in binaryScope7bit) {
      if (binaryDevider == ascii) {
        binaryLetter += "1";
        ascii = 0;
        continue;
      }

      if (ascii > binaryDevider) {
        binaryLetter += "1";
        ascii = ascii - binaryDevider;
      } else {
        binaryLetter += "0";
      }
    }
    binaryScentence.add(binaryLetter);
    binaryLetter = '';
  }
  return binaryScentence;
}

binaryToAscii(List<String> binaryScentence) {
  int ascii = 0;

  String scentence = '';

  for (String letter in binaryScentence) {
    for (int i = 0; i < letter.length; i++) {
      if (letter[i] == "1") {
        ascii += binaryScope7bit[i];
      }
    }
    scentence += String.fromCharCode(ascii);
    ascii = 0;
  }

  return scentence;
}

dynamic binaryToString(String string) {
  String newString = "";
  List<int> asciiList = [];
  int asciiLetter = 0;
  bool is8bit = false;

  for (int i = 0; i < string.length; i++) {
    if (string[i] != ' ') {
      if (string[i] != "1" && string[i] != "0") {
        return "INVALID BINARY";
      }
      newString += string[i];
    }
  }

  if (newString.length % 7 != 0) {
    if (newString.length % 8 != 0) {
      return "INVALID BINARY";
    }
    is8bit = true;
  }
  int bitSize = 7;
  List<int> binaryScope = binaryScope7bit;
  if (is8bit) {
    bitSize = 8;
    binaryScope = binaryScope8bit;
  }
  for (int i = 0; i < newString.length / bitSize; i++) {
    for (int j = 0; j < bitSize; j++) {
      if (newString[j + (i * bitSize)] == "1") {
        asciiLetter += binaryScope[j];
      }
    }
    asciiList.add(asciiLetter);
    asciiLetter = 0;
  }
  String message = "";
  for (int ascii in asciiList) {
    message += String.fromCharCode(ascii);
  }
  return message;
}
