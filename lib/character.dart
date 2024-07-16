import 'package:rpbot/status.dart' as status;

class Character {
  final String name;
  List<String> debuffs = [], buffs = [];

  Character(this.name);

  bool addBuff(String buff) {
    if (!status.buffs.containsKey(buff)) {
      return false;
    }
    buffs.add(buff);
    return true;
  }

  bool addDebuff(String debuff) {
    if (!status.debuffs.containsKey(debuff)) {
      return false;
    }
    debuffs.add(debuff);
    return true;
  }

  bool removeBuff(String buff) {
    if (!buffs.contains(buff)) {
      return false;
    }
    buffs.removeAt(buffs.indexOf(buff));
    return true;
  }

  bool removeDebuff(String debuff) {
    if (!debuffs.contains(debuff)) {
      return false;
    }
    debuffs.removeAt(debuffs.indexOf(debuff));
    return true;
  }
}
