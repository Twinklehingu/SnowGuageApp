import 'dart:math';

class IdGenerator {
  static int generateId() {
    Random random = Random();

    int randomInt1 = random.nextInt(1000);
    int randomInt2 = random.nextInt(1000);
    int randomInt3 = random.nextInt(1000);

    String id = randomInt1.toString() +
        randomInt2.toString() +
        randomInt3.toString();

    return int.parse(id);
  }
}