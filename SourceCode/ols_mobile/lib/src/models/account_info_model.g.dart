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
      json['mobilePhone'] as String,
      json['image'] as int,
      json['birthday'] as String,
      json['gender'] as String,
      json['countryCode'] as String,
      json['connectedFacebook'] as bool,
      json['connectedGoogle'] as bool,
      json['urlAvatar'] as String,
      json['csn'] as String,
      (json['balance'] as num)?.toDouble(),
      json['unReadNotificationCount'] as int);
}

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'csn': instance.csn,
      'fullName': instance.fullName,
      'unReadNotificationCount': instance.unReadNotificationCount,
      'mobilePhone': instance.phone,
      'image': instance.image,
      'urlAvatar': instance.urlAvatar,
      'countryCode': instance.countryCode,
      'birthday': instance.birthday,
      'connectedFacebook': instance.connectedFacebook,
      'connectedGoogle': instance.connectedGoogle,
      'gender': instance.gender,
      'balance': instance.balance
    };
