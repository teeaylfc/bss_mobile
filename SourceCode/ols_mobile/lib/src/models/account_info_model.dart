import 'package:json_annotation/json_annotation.dart';
part 'account_info_model.g.dart';

@JsonSerializable()
class AccountInfo {
  final int id;
  final String email;

  final String csn;

  final String fullName;

  final int unReadNotificationCount;

  @JsonKey(name: 'mobilePhone')
  final String phone;
  final int image;
  final String urlAvatar;
  final String countryCode;
  final String birthday;
  final bool connectedFacebook;
  final bool connectedGoogle;
  final String gender;
  final double balance;

  const AccountInfo(this.id, this.email, this.fullName, this.phone, this.image, this.birthday, this.gender, this.countryCode, this.connectedFacebook,
      this.connectedGoogle, this.urlAvatar, this.csn, this.balance, this.unReadNotificationCount);

  factory AccountInfo.fromJson(Map<String, dynamic> json) => _$AccountInfoFromJson(json);
}
