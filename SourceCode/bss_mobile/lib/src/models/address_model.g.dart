// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      name: json['name'] as int,
      specificAddress: json['specificAddress'] as String,
      district: json['district'] == null
          ? null
          : District.fromJson(json['district'] as Map<String, dynamic>),
      town: json['town'] == null
          ? null
          : Commune.fromJson(json['town'] as Map<String, dynamic>),
      description: json['description'] as String,
      stadiumDTOs: (json['stadiumDTOs'] as List)
          ?.map((e) =>
              e == null ? null : Stadium.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      id: json['id'] as int);
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'specificAddress': instance.specificAddress,
      'description': instance.description,
      'district': instance.district,
      'town': instance.town,
      'stadiumDTOs': instance.stadiumDTOs
    };
