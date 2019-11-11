// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stadium_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stadium _$StadiumFromJson(Map<String, dynamic> json) {
  return Stadium(
      id: json['id'] as int,
      maType: json['maType'] as int,
      name: json['name'] as String,
      statusShiftResponses: (json['statusShiftResponses'] as List)
          ?.map((e) =>
              e == null ? null : Shift.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      description: json['description'] as String);
}

Map<String, dynamic> _$StadiumToJson(Stadium instance) => <String, dynamic>{
      'id': instance.id,
      'maType': instance.maType,
      'name': instance.name,
      'description': instance.description,
      'statusShiftResponses': instance.statusShiftResponses
    };
