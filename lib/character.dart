import 'package:rpbot/status.dart' as status;
import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {
  final String name;
  int total = 0;
  List<String> debuffs = [], buffs = [];

  Character(this.name);

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

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
