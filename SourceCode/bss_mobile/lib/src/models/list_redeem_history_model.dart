import 'package:bss_mobile/src/models/pageable_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bss_mobile/src/models/redeem_history_model.dart';


part 'list_redeem_history_model.g.dart';

@JsonSerializable()
class ListRedeemHistory extends Pageable {
  final List<RedeemHistory> content;
  final bool last;

  ListRedeemHistory({this.content, this.last});

  factory ListRedeemHistory.fromJson(Map<String, dynamic> json) =>
      _$ListRedeemHistoryFromJson(json);
}
