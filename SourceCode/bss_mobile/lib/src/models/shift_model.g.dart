// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shift _$ShiftFromJson(Map<String, dynamic> json) {
  return Shift(
      id: json['id'] as int,
      shiftDTO: json['shiftDTO'] == null
          ? null
          : ShiftDTO.fromJson(json['shiftDTO'] as Map<String, dynamic>),
      status: json['status'] as int,
      user: json['user'] == null
          ? null
          : AccountInfo.fromJson(json['user'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ShiftToJson(Shift instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'shiftDTO': instance.shiftDTO,
      'user': instance.user
    };
