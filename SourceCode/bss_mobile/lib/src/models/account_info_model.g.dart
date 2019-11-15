// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) {
  return AccountInfo(
      json['id'] as int,
      json['email'] as String,
      json['fullName'] as String,
      json['phone'] as String,
      json['image'] as int,
      json['gender'] as String,
      json['connectedFacebook'] as bool,
      json['connectedGoogle'] as bool,
      json['imageURL'] as String,
      (json['balance'] as num)?.toDouble());
}

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'image': instance.image,
      'imageURL': instance.imageURL,
      'connectedFacebook': instance.connectedFacebook,
      'connectedGoogle': instance.connectedGoogle,
      'gender': instance.gender,
      'balance': instance.balance
    };
