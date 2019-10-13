import 'package:json_annotation/json_annotation.dart';

part 'balance_detail_model.g.dart';


@JsonSerializable()
class BalanceDetail {
  double balance;
  SoonExpired soonExpiredBalance;
  BalanceDetail(this.balance, this.soonExpiredBalance);
  factory BalanceDetail.fromJson(Map<String, dynamic> json) => _$BalanceDetailFromJson(json);
}

@JsonSerializable()
class SoonExpired {
  double soonExpiryBalance;
  String expiryDate;
  SoonExpired(this.soonExpiryBalance, this.expiryDate);
  factory SoonExpired.fromJson(Map<String, dynamic> json) => _$SoonExpiredFromJson(json);

}