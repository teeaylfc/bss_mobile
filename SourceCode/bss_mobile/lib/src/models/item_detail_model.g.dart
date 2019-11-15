// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemDetail _$ItemDetailFromJson(Map<String, dynamic> json) {
  return ItemDetail(
      json['id'] as int,
      json['name'] as String,
      json['image'] as int,
      json['overview'] as String,
      (json['distance'] as num)?.toDouble(),
      json['startDate'] as String,
      json['endDate'] as String,
      json['openHours'] as String,
      json['categoryName'] as String,
      json['merchantName'] as String,
      json['about'] as String,
      json['contact'] as String,
      json['address'] as String,
      json['website'] as String,
      json['totalFavorite'] as int,
      (json['listReview'] as List)
          ?.map((e) =>
              e == null ? null : Review.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['reviewDTO'] == null
          ? null
          : Rating.fromJson(json['reviewDTO'] as Map<String, dynamic>),
      json['companyId'] as int,
      json['imageCompany'] as int,
      (json['listStores'] as List)
          ?.map((e) =>
              e == null ? null : Store.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['bookingReservation'] as bool,
      json['basicOfAward'] as String,
      json['likeStatus'] as bool,
      json['checkOfferInWallet'] as bool,
      json['remainingTime'] as String);
}

Map<String, dynamic> _$ItemDetailToJson(ItemDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'overview': instance.overview,
      'distance': instance.distance,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'openHours': instance.openHours,
      'categoryName': instance.categoryName,
      'merchantName': instance.merchantName,
      'contact': instance.contact,
      'address': instance.address,
      'about': instance.about,
      'companyId': instance.companyId,
      'imageCompany': instance.imageCompany,
      'bookingReservation': instance.bookingReservation,
      'basicOfAward': instance.basicOfAward,
      'likeStatus': instance.likeStatus,
      'checkOfferInWallet': instance.checkOfferInWallet,
      'remainingTime': instance.remainingTime,
      'website': instance.website,
      'totalFavorite': instance.totalFavorite,
      'listReview': instance.listReview,
      'listStores': instance.listStores,
      'reviewDTO': instance.reviewDTO
    };

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return Review(
      json['id'] as int,
      json['tittle'] as String,
      json['review'] as String,
      json['rate'] as int,
      json['companyId'] as int,
      json['consumerId'] as int,
      json['createdBy'] as String,
      json['createdDate'] as String,
      json['distributorId'] as int,
      json['consumerName'] as String);
}

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'id': instance.id,
      'distributorId': instance.distributorId,
      'companyId': instance.companyId,
      'consumerId': instance.consumerId,
      'rate': instance.rate,
      'review': instance.review,
      'tittle': instance.tittle,
      'consumerName': instance.consumerName
    };

Rating _$RatingFromJson(Map<String, dynamic> json) {
  return Rating(
      json['companyId'] as int,
      json['totalRate'] as int,
      (json['averagePoint'] as num)?.toDouble(),
      (json['listPoint'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(k, (e as num)?.toDouble()),
      ));
}

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'companyId': instance.companyId,
      'totalRate': instance.totalRate,
      'averagePoint': instance.averagePoint,
      'listPoint': instance.listPoint
    };
