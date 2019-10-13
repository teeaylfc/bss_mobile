// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListMobileNotification _$ListMobileNotificationFromJson(
    Map<String, dynamic> json) {
  return ListMobileNotification(
      content: (json['content'] as List)
          ?.map((e) => e == null
              ? null
              : MobileNotification.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      last: json['last'] as bool);
}

Map<String, dynamic> _$ListMobileNotificationToJson(
        ListMobileNotification instance) =>
    <String, dynamic>{'content': instance.content, 'last': instance.last};

MobileNotification _$MobileNotificationFromJson(Map<String, dynamic> json) {
  return MobileNotification(
      messageId: json['messageId'] as String,
      messageTitle: json['messageTitle'] as String,
      messageContent: json['messageContent'] as String,
      readInd: json['readInd'] as String,
      receiveTime: json['receiveTime'] as String,
      receivedDateTime: json['receivedDateTime'] as String);
}

Map<String, dynamic> _$MobileNotificationToJson(MobileNotification instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'messageTitle': instance.messageTitle,
      'messageContent': instance.messageContent,
      'readInd': instance.readInd,
      'receiveTime': instance.receiveTime,
      'receivedDateTime': instance.receivedDateTime
    };
