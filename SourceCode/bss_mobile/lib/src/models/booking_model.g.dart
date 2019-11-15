// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingList _$BookingListFromJson(Map<String, dynamic> json) {
  return BookingList(
      (json['content'] as List)
          ?.map((e) =>
              e == null ? null : Booking.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['last'] as bool);
}

Map<String, dynamic> _$BookingListToJson(BookingList instance) =>
    <String, dynamic>{'last': instance.last, 'content': instance.content};

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return Booking(
      id: json['id'] as int,
      bookingDate: json['bookingDate'] as String,
      offerId: json['offerId'] as int,
      offerImage: json['offerImage'] as int,
      fulfillmentPartnerId: json['fulfillmentPartnerId'] as int,
      offerName: json['offerName'] as String,
      addressFulfillment: json['addressFulfillment'] as String,
      storeName: json['storeName'] as String,
      bookingStatus: json['bookingStatus'] as String,
      contactName: json['contactName'] as String,
      contactPhone: json['contactPhone'] as String,
      storeLatitude: (json['storeLatitude'] as num)?.toDouble(),
      storeLongitude: (json['storeLongitude'] as num)?.toDouble(),
      quantityAdult: json['quantityAdult'] as int,
      quantityChildren: json['quantityChildren'] as int,
      note: json['note'] as String,
      listStores: (json['listStores'] as List)
          ?.map((e) =>
              e == null ? null : Store.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'id': instance.id,
      'offerImage': instance.offerImage,
      'bookingDate': instance.bookingDate,
      'offerId': instance.offerId,
      'fulfillmentPartnerId': instance.fulfillmentPartnerId,
      'offerName': instance.offerName,
      'addressFulfillment': instance.addressFulfillment,
      'storeName': instance.storeName,
      'bookingStatus': instance.bookingStatus,
      'contactName': instance.contactName,
      'contactPhone': instance.contactPhone,
      'storeLongitude': instance.storeLongitude,
      'storeLatitude': instance.storeLatitude,
      'listStores': instance.listStores,
      'quantityAdult': instance.quantityAdult,
      'quantityChildren': instance.quantityChildren,
      'note': instance.note
    };
