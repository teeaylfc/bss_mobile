import 'package:json_annotation/json_annotation.dart';
part 'account_info_model.g.dart';

@JsonSerializable()
class AccountInfo {
  final int id;
  final String email;
  final String fullName;
  final String phone;
  final int image;
  final String imageURL;
  final bool connectedFacebook;
  final bool connectedGoogle;
  final String gender;
  final double balance;

  const AccountInfo(this.id, this.email, this.fullName, this.phone, this.image, this.gender, this.connectedFacebook,
      this.connectedGoogle, this.imageURL, this.balance,);

  factory AccountInfo.fromJson(Map<String, dynamic> json) => _$AccountInfoFromJson(json);
}
