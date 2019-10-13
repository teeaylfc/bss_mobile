// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddress _$ShippingAddressFromJson(Map<String, dynamic> json) {
  return ShippingAddress(
      json['customerName'] as String,
      json['companyName'] as String,
      json['email'] as String,
      json['phone'] as String,
      json['address'] as String,
      json['city'] as String,
      json['district'] as String);
}

Map<String, dynamic> _$ShippingAddressToJson(ShippingAddress instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'companyName': instance.companyName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'district': instance.district
    };
