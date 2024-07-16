import 'dart:math';

int rollD20() {
  var rng = Random();
  return rng.nextInt(20) + 1;
}
