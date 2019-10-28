// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stadium_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stadium _$StadiumFromJson(Map<String, dynamic> json) {
  return Stadium(
      id: json['id'] as int,
      name: json['name'] as String,
      shiftDTOs: (json['shiftDTOs'] as List)
          ?.map((e) =>
              e == null ? null : Shift.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$StadiumToJson(Stadium instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shiftDTOs': instance.shiftDTOs
    };
