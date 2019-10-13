// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListStore _$ListStoreFromJson(Map<String, dynamic> json) {
  return ListStore(
      content: (json['content'] as List)
          ?.map((e) =>
              e == null ? null : Store.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      last: json['last'] as bool);
}

Map<String, dynamic> _$ListStoreToJson(ListStore instance) =>
    <String, dynamic>{'content': instance.content, 'last': instance.last};

Store _$StoreFromJson(Map<String, dynamic> json) {
  return Store(
      json['storeId'] as String,
      json['address'] as String,
      json['website'] as String,
      json['storeName'] as String,
      json['logoUrl'] as String,
      json['phone'] as String,
      json['description'] as String,
      json['favourite'] as bool,
      json['favouriteCount'] as int)
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..latitude = (json['latitude'] as num)?.toDouble();
}

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'storeId': instance.storeId,
      'address': instance.address,
      'website': instance.website,
      'storeName': instance.storeName,
      'logoUrl': instance.logoUrl,
      'phone': instance.phone,
      'description': instance.description,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'favourite': instance.favourite,
      'favouriteCount': instance.favouriteCount
    };
