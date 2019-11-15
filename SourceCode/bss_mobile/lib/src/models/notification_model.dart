import 'package:bss_mobile/src/models/list_transaction_model.dart';
import 'package:bss_mobile/src/models/pageable_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'notification_model.g.dart';

@JsonSerializable()
class ListMobileNotification extends Pageable {
  final List<MobileNotification> content;
  final bool last;

  ListMobileNotification({this.content, this.last});

  factory ListMobileNotification.fromJson(Map<String, dynamic> json) => _$ListMobileNotificationFromJson(json);
}

@JsonSerializable()
class MobileNotification {
    final String messageId;
  final String messageTitle;
  final String messageContent;
  final String readInd;
  final String receiveTime;
  final String receivedDateTime;

  MobileNotification({this.messageId, this.messageTitle, this.messageContent, this.readInd, this.receiveTime,this.receivedDateTime,});

  factory MobileNotification.fromJson(Map<String, dynamic> json) => _$MobileNotificationFromJson(json);
}
