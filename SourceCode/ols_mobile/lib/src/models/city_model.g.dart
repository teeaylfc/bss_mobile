// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) {
  return City(
      matp: json['matp'] as String,
      name: json['name'] as String,
      type: json['type'] as String);
}

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'matp': instance.matp,
      'name': instance.name,
      'type': instance.type
    };
