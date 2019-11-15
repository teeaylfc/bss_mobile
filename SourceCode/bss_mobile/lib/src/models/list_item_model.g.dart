// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListItem _$ListItemFromJson(Map<String, dynamic> json) {
  return ListItem(
      content: (json['content'] as List)
          ?.map((e) =>
              e == null ? null : Item.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      last: json['last'] as bool,
      totalElements: json['totalElements'] as int);
}

Map<String, dynamic> _$ListItemToJson(ListItem instance) => <String, dynamic>{
      'content': instance.content,
      'last': instance.last,
      'totalElements': instance.totalElements
    };
