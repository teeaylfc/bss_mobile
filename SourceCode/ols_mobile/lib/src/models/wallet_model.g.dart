// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) {
  return Wallet(
      json['pages'] == null
          ? null
          : ListItem.fromJson(json['pages'] as Map<String, dynamic>),
      json['totalQuatity'] as int);
}

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'pages': instance.pages,
      'totalQuatity': instance.totalQuatity
    };
