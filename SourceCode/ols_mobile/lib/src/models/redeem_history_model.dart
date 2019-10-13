import 'package:json_annotation/json_annotation.dart';
import 'package:ols_mobile/src/models/item_model.dart';
part 'redeem_history_model.g.dart';

@JsonSerializable()
class RedeemHistory {
  final int quantity;
  final String redeemDate;
  final double pointRedeem;
  final Item item;
  RedeemHistory({this.quantity, this.redeemDate, this.pointRedeem,this.item});

  factory RedeemHistory.fromJson(Map<String, dynamic> json) =>
      _$RedeemHistoryFromJson(json);
}