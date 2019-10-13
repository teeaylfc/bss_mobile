// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeem_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedeemHistory _$RedeemHistoryFromJson(Map<String, dynamic> json) {
  return RedeemHistory(
      quantity: json['quantity'] as int,
      redeemDate: json['redeemDate'] as String,
      pointRedeem: (json['pointRedeem'] as num)?.toDouble(),
      item: json['item'] == null
          ? null
          : Item.fromJson(json['item'] as Map<String, dynamic>));
}

Map<String, dynamic> _$RedeemHistoryToJson(RedeemHistory instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'redeemDate': instance.redeemDate,
      'pointRedeem': instance.pointRedeem,
      'item': instance.item
    };
