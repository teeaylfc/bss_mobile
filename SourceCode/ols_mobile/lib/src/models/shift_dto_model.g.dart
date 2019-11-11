// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftDTO _$ShiftDTOFromJson(Map<String, dynamic> json) {
  return ShiftDTO(
      id: json['id'] as int,
      name: json['name'] as int,
      cash: (json['cash'] as num)?.toDouble());
}

Map<String, dynamic> _$ShiftDTOToJson(ShiftDTO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cash': instance.cash
    };
