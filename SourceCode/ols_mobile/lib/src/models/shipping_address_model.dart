import 'package:json_annotation/json_annotation.dart';
import 'package:ols_mobile/src/models/pageable_model.dart';

part 'shipping_address_model.g.dart';

@JsonSerializable()
class ShippingAddress extends Pageable {
  String customerName;
  String companyName;
  String email;
  String phone;
  String address;
  String city;
  String district;

  ShippingAddress(this.customerName, this.companyName, this.email, this.phone,
      this.address, this.city, this.district);

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => _$ShippingAddressFromJson(json);
}