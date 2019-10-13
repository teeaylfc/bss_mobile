// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceDetail _$BalanceDetailFromJson(Map<String, dynamic> json) {
  return BalanceDetail(
      (json['balance'] as num)?.toDouble(),
      json['soonExpiredBalance'] == null
          ? null
          : SoonExpired.fromJson(
              json['soonExpiredBalance'] as Map<String, dynamic>));
}

Map<String, dynamic> _$BalanceDetailToJson(BalanceDetail instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'soonExpiredBalance': instance.soonExpiredBalance
    };

SoonExpired _$SoonExpiredFromJson(Map<String, dynamic> json) {
  return SoonExpired((json['soonExpiryBalance'] as num)?.toDouble(),
      json['expiryDate'] as String);
}

Map<String, dynamic> _$SoonExpiredToJson(SoonExpired instance) =>
    <String, dynamic>{
      'soonExpiryBalance': instance.soonExpiryBalance,
      'expiryDate': instance.expiryDate
    };
