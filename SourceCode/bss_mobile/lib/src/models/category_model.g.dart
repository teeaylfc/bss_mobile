// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryList _$CategoryListFromJson(Map<String, dynamic> json) {
  return CategoryList(
      (json['content'] as List)
          ?.map((e) =>
              e == null ? null : Category.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['last'] as bool);
}

Map<String, dynamic> _$CategoryListToJson(CategoryList instance) =>
    <String, dynamic>{'last': instance.last, 'content': instance.content};

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
      categoryCode: json['categoryCode'] as String,
      categoryDescription: json['categoryDescription'] as String,
      imageDTO: json['imageDTO'] == null
          ? null
          : ImageDTO.fromJson(json['imageDTO'] as Map<String, dynamic>),
      itemDTOS: (json['itemDTOS'] as List)
          ?.map((e) =>
              e == null ? null : Item.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'categoryCode': instance.categoryCode,
      'categoryDescription': instance.categoryDescription,
      'imageDTO': instance.imageDTO,
      'itemDTOS': instance.itemDTOS
    };
