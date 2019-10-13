import 'package:json_annotation/json_annotation.dart';
part 'pageable_model.g.dart';

@JsonSerializable()
class Pageable {
  final int totalElements;
  final int totalPages;
  final bool last;
  Pageable({this.totalElements, this.totalPages, this.last});

  factory Pageable.fromJson(Map<String, dynamic> json) =>
      _$PageableFromJson(json);
}
