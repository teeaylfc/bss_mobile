// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_redeem_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListRedeemHistory _$ListRedeemHistoryFromJson(Map<String, dynamic> json) {
  return ListRedeemHistory(
      content: (json['content'] as List)
          ?.map((e) => e == null
              ? null
              : RedeemHistory.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      last: json['last'] as bool);
}

Map<String, dynamic> _$ListRedeemHistoryToJson(ListRedeemHistory instance) =>
    <String, dynamic>{'content': instance.content, 'last': instance.last};
