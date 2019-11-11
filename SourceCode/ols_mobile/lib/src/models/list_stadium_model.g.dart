// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_stadium_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListStadium _$ListStadiumFromJson(Map<String, dynamic> json) {
  return ListStadium(
      address: (json['address'] as List)
          ?.map((e) =>
              e == null ? null : Stadium.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ListStadiumToJson(ListStadium instance) =>
    <String, dynamic>{'address': instance.address};
