// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pageable_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pageable _$PageableFromJson(Map<String, dynamic> json) {
  return Pageable(
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      last: json['last'] as bool);
}

Map<String, dynamic> _$PageableToJson(Pageable instance) => <String, dynamic>{
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last
    };
