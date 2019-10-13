// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
      itemCode: json['itemCode'] as String,
      voucherCode: json['voucherCode'] as String,
      itemName: json['itemName'] as String,
      companyName: json['companyName'] as String,
      termAndConditions: json['termAndConditions'] as String,
      description: json['description'] as String,
      itemPrice: (json['itemPrice'] as num)?.toDouble(),
      imageDTO: (json['imageDTO'] as List)
          ?.map((e) =>
              e == null ? null : ImageDTO.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      effectiveDate: json['effectiveDate'] as String,
      remainingDay: json['remainingDay'] as String,
      expired: json['expired'] as bool,
      categoryDescription: json['categoryDescription'] as String,
      redeemLocation: (json['redeemLocation'] as List)
          ?.map((e) =>
              e == null ? null : Store.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      favourite: json['favourite'] as bool,
      favouriteCount: json['favouriteCount'] as int,
      quantity: json['quantity'] as int,
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      store: json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'voucherCode': instance.voucherCode,
      'itemCode': instance.itemCode,
      'itemName': instance.itemName,
      'companyName': instance.companyName,
      'termAndConditions': instance.termAndConditions,
      'itemPrice': instance.itemPrice,
      'effectiveDate': instance.effectiveDate,
      'remainingDay': instance.remainingDay,
      'categoryDescription': instance.categoryDescription,
      'description': instance.description,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'quantity': instance.quantity,
      'store': instance.store,
      'expired': instance.expired,
      'favourite': instance.favourite,
      'favouriteCount': instance.favouriteCount,
      'imageDTO': instance.imageDTO,
      'redeemLocation': instance.redeemLocation
    };

ImageDTO _$ImageDTOFromJson(Map<String, dynamic> json) {
  return ImageDTO(
      imageUrl: json['imageUrl'] as String,
      imagePath: json['imagePath'] as String);
}

Map<String, dynamic> _$ImageDTOToJson(ImageDTO instance) => <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'imagePath': instance.imagePath
    };

OrderList _$OrderListFromJson(Map<String, dynamic> json) {
  return OrderList(
      items: (json['items'] as List)
          ?.map((e) =>
              e == null ? null : Item.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      totalPoint: (json['totalPoint'] as num)?.toDouble(),
      totalElements: json['totalElements'] as int,
      totalItemExpired: json['totalItemExpired'] as int,
      totalItemReadyCheckout: json['totalItemReadyCheckout'] as int);
}

Map<String, dynamic> _$OrderListToJson(OrderList instance) => <String, dynamic>{
      'items': instance.items,
      'totalPoint': instance.totalPoint,
      'totalElements': instance.totalElements,
      'totalItemExpired': instance.totalItemExpired,
      'totalItemReadyCheckout': instance.totalItemReadyCheckout
    };

MyReward _$MyRewardFromJson(Map<String, dynamic> json) {
  return MyReward(
      voucherCode: json['voucherCode'] as String,
      quantity: json['quantity'] as int,
      startDate: json['startDate'] as String,
      expiryDate: json['expiryDate'] as String,
      expired: json['expired'] as bool,
      item: json['item'] == null
          ? null
          : Item.fromJson(json['item'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MyRewardToJson(MyReward instance) => <String, dynamic>{
      'voucherCode': instance.voucherCode,
      'quantity': instance.quantity,
      'startDate': instance.startDate,
      'expiryDate': instance.expiryDate,
      'expired': instance.expired,
      'item': instance.item
    };

ListMyReward _$ListMyRewardFromJson(Map<String, dynamic> json) {
  return ListMyReward(
      content: (json['content'] as List)
          ?.map((e) =>
              e == null ? null : MyReward.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      last: json['last'] as bool,
      totalElements: json['totalElements'] as int);
}

Map<String, dynamic> _$ListMyRewardToJson(ListMyReward instance) =>
    <String, dynamic>{
      'content': instance.content,
      'last': instance.last,
      'totalElements': instance.totalElements
    };
