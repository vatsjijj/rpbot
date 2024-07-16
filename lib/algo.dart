import 'dart:math';

int rollD20() {
  var rng = Random();
  return rng.nextInt(20) + 1;
}

String sentenceCase(String str) {
  if (str.isNotEmpty) {
    var sp = str.split(' ');
    return sp
        .map((e) => '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}')
        .join(' ');
  }
  return str;
}
