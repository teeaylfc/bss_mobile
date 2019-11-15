import 'package:bss_mobile/src/models/store_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'item_detail_model.g.dart';

@JsonSerializable()
class ItemDetail {
  final int id;
  final String name;
  final int image;
  final String overview;
  final double distance;
  final String startDate;
  final String endDate;
  final String openHours;
  final String categoryName;
  final String merchantName;
  final String contact;
  final String address;
  final String about;
  final int companyId;
  final int imageCompany;
  final bool bookingReservation;
  final String basicOfAward;
  bool likeStatus;
  bool checkOfferInWallet;
  final String remainingTime;
  final String website;
  final int totalFavorite;
  final List<Review> listReview;
  final List<Store> listStores;
  final Rating reviewDTO;

  ItemDetail(
      this.id,
      this.name,
      this.image,
      this.overview,
      this.distance,
      this.startDate,
      this.endDate,
      this.openHours,
      this.categoryName,
      this.merchantName,
      this.about,
      this.contact,
      this.address,
      this.website,
      this.totalFavorite,
      this.listReview,
      this.reviewDTO,
      this.companyId,
      this.imageCompany,
      this.listStores,
      this.bookingReservation,
      this.basicOfAward,
      this.likeStatus,
      this.checkOfferInWallet,
      this.remainingTime);
  factory ItemDetail.fromJson(Map<String, dynamic> json) => _$ItemDetailFromJson(json);
}

@JsonSerializable()
class Review {
  final String createdBy;
  final String createdDate;
  final int id;
  final int distributorId;
  final int companyId;
  final int consumerId;
  final int rate;
  final String review;
  final String tittle;
  final String consumerName;

  Review(this.id, this.tittle, this.review, this.rate, this.companyId, this.consumerId, this.createdBy, this.createdDate, this.distributorId,this.consumerName);

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

}

@JsonSerializable()
class Rating {
  final int companyId;
  final int totalRate;
  final double averagePoint;

  final Map<String, double> listPoint;

  Rating(this.companyId, this.totalRate, this.averagePoint, this.listPoint);

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
}


