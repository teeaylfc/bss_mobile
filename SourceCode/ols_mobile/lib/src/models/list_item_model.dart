import 'package:ols_mobile/src/models/pageable_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'item_model.dart';

part 'list_item_model.g.dart';

@JsonSerializable()
class ListItem extends Pageable {
  final List<Item> content;
  final bool last;
  final int totalElements;

  ListItem({this.content, this.last, this.totalElements});

  factory ListItem.fromJson(Map<String, dynamic> json) =>
      _$ListItemFromJson(json);
}
