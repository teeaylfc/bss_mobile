// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListAddress _$ListAddressFromJson(Map<String, dynamic> json) {
  return ListAddress(
      address: (json['address'] as List)
          ?.map((e) =>
              e == null ? null : Address.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ListAddressToJson(ListAddress instance) =>
    <String, dynamic>{'address': instance.address};
