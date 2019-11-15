// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commune_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Commune _$CommuneFromJson(Map<String, dynamic> json) {
  return Commune(
      xaid: json['xaid'] as String,
      name: json['name'] as String,
      type: json['type'] as String);
}

Map<String, dynamic> _$CommuneToJson(Commune instance) => <String, dynamic>{
      'xaid': instance.xaid,
      'name': instance.name,
      'type': instance.type
    };
