import 'package:rpbot/character.dart';
import 'package:json_annotation/json_annotation.dart';

part 'context.g.dart';

@JsonSerializable()
class Context {
  Map<String, Character> characters = {};

  Context();

  factory Context.fromJson(Map<String, dynamic> json) =>
      _$ContextFromJson(json);

  Map<String, dynamic> toJson() => _$ContextToJson(this);

  bool addCharacter(String name) {
    if (characters.containsKey(name)) {
      print(characters);
      print('$name could not be created');
      return false;
    }
    characters[name] = Character(name);
    return true;
  }

  bool removeCharacter(String name) {
    if (!characters.containsKey(name)) {
      print(characters);
      print('$name could not be removed');
      return false;
    }
    characters.remove(name);
    return true;
  }
}
