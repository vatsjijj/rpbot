// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      json['name'] as String,
    )
      ..debuffs =
          (json['debuffs'] as List<dynamic>).map((e) => e as String).toList()
      ..buffs =
          (json['buffs'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'name': instance.name,
      'debuffs': instance.debuffs,
      'buffs': instance.buffs,
    };
