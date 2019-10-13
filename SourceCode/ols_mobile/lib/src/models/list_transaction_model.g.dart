// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTransaction _$ListTransactionFromJson(Map<String, dynamic> json) {
  return ListTransaction(
      content: (json['content'] as List)
          ?.map((e) => e == null
              ? null
              : Transaction.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      last: json['last'] as bool);
}

Map<String, dynamic> _$ListTransactionToJson(ListTransaction instance) =>
    <String, dynamic>{'content': instance.content, 'last': instance.last};

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction(
      json['transactionId'] as int,
      (json['netAmount'] as num)?.toDouble(),
      (json['discountAmount'] as num)?.toDouble(),
      (json['grossAmount'] as num)?.toDouble(),
      json['description'] as String,
      json['subject'] as String,
      json['storeAddress'] as String,
      json['storeImage'] as int,
      json['txnDatetime'] as String,
      (json['offerRedeems'] as List)
          ?.map((e) => e == null
              ? null
              : CouponTransaction.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['awardAmount'] as num)?.toDouble(),
      (json['point'] as num)?.toDouble(),
      json['txnType'] as String);
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'netAmount': instance.netAmount,
      'discountAmount': instance.discountAmount,
      'grossAmount': instance.grossAmount,
      'transactionId': instance.transactionId,
      'awardAmount': instance.awardAmount,
      'point': instance.point,
      'txnType': instance.txnType,
      'description': instance.description,
      'subject': instance.subject,
      'storeAddress': instance.storeAddress,
      'storeImage': instance.storeImage,
      'txnDatetime': instance.txnDatetime,
      'offerRedeems': instance.offerRedeems
    };

CouponTransaction _$CouponTransactionFromJson(Map<String, dynamic> json) {
  return CouponTransaction(
      json['offerId'] as int,
      json['offerName'] as String,
      json['companyName'] as String,
      json['image'] as int,
      json['quantity'] as int);
}

Map<String, dynamic> _$CouponTransactionToJson(CouponTransaction instance) =>
    <String, dynamic>{
      'offerId': instance.offerId,
      'offerName': instance.offerName,
      'companyName': instance.companyName,
      'image': instance.image,
      'quantity': instance.quantity
    };
