// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shift _$ShiftFromJson(Map<String, dynamic> json) {
  return Shift(
      id: json['id'] as int,
      name: json['name'] as String,
      time: json['time'] as String,
      cash: (json['cash'] as num)?.toDouble());
}

Map<String, dynamic> _$ShiftToJson(Shift instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'time': instance.time,
      'cash': instance.cash
    };
