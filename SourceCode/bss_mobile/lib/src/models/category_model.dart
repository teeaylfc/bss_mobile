import 'package:json_annotation/json_annotation.dart';
import 'package:bss_mobile/src/models/pageable_model.dart';

import 'item_model.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryList extends Pageable {
  final bool last;
  final List<Category> content;

  CategoryList(this.content, this.last);
  factory CategoryList.fromJson(Map<String, dynamic> json) => _$CategoryListFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryListToJson(this);
}

@JsonSerializable()
class Category {
  final String categoryCode;
  final String categoryDescription;
  ImageDTO imageDTO;
  List<Item> itemDTOS;

  Category({this.categoryCode, this.categoryDescription, this.imageDTO, this.itemDTOS});

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
