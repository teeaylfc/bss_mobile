import 'package:json_annotation/json_annotation.dart';

import 'list_item_model.dart';

part 'wallet_model.g.dart';


@JsonSerializable()
class Wallet {
  final ListItem pages;
  final int totalQuatity;

  Wallet(this.pages, this.totalQuatity);

   factory Wallet.fromJson(Map<String, dynamic> json) =>
      _$WalletFromJson(json);
}
