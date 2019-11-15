
import 'package:bss_mobile/src/models/pageable_model.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'item_detail_model.dart';
part 'list_review_model.g.dart';

@JsonSerializable()
class ListReview extends Pageable {
  final List<Review> content;
  final bool last;
  final int totalElements;

  ListReview({this.content, this.last,this.totalElements});

  factory ListReview.fromJson(Map<String, dynamic> json) =>
      _$ListReviewFromJson(json);

}
