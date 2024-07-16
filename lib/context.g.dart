// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Context _$ContextFromJson(Map<String, dynamic> json) => Context()
  ..characters = (json['characters'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, Character.fromJson(e as Map<String, dynamic>)),
  );

Map<String, dynamic> _$ContextToJson(Context instance) => <String, dynamic>{
      'characters': instance.characters,
    };
