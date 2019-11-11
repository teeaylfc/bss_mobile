import 'package:json_annotation/json_annotation.dart';
import 'package:ols_mobile/src/models/address_model.dart';
part 'list_address_model.g.dart';

@JsonSerializable()
class ListAddress {
  List<Address> address;
  ListAddress({this.address});
  factory ListAddress.fromJson(Map<String, dynamic> json) => _$ListAddressFromJson(json);
}