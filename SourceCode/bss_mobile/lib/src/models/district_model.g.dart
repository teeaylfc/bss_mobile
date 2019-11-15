// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

District _$DistrictFromJson(Map<String, dynamic> json) {
  return District(
      maqh: json['maqh'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      townDTOs: (json['townDTOs'] as List)
          ?.map((e) =>
              e == null ? null : Commune.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DistrictToJson(District instance) => <String, dynamic>{
      'maqh': instance.maqh,
      'name': instance.name,
      'type': instance.type,
      'townDTOs': instance.townDTOs
    };
