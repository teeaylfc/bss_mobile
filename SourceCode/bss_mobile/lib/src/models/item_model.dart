import 'package:json_annotation/json_annotation.dart';
import 'package:bss_mobile/src/models/pageable_model.dart';
import 'package:bss_mobile/src/models/store_model.dart';

part 'item_model.g.dart';

@JsonSerializable()
class Item {
  final String voucherCode;

  final String itemCode;
  final String itemName;
  final String companyName;
  final String termAndConditions;
  final double itemPrice;
  final String effectiveDate;
  final String remainingDay;
  final String categoryDescription;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  int quantity;
  final Store store;

  final bool expired;
  bool favourite = false;
  final int favouriteCount;

  final List<ImageDTO> imageDTO;
  final List<Store> redeemLocation;
  Item(
      {this.itemCode,
      this.voucherCode,
      this.itemName,
      this.companyName,
      this.termAndConditions,
      this.description,
      this.itemPrice,
      this.imageDTO,
      this.effectiveDate,
      this.remainingDay,
      this.expired,
      this.categoryDescription,
      this.redeemLocation,
      this.favourite,
      this.favouriteCount,
      this.quantity,
      this.endDate,
      this.startDate,
      this.store});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class ImageDTO {
  final String imageUrl;
  final String imagePath;

  const ImageDTO({this.imageUrl, this.imagePath});

  factory ImageDTO.fromJson(Map<String, dynamic> json) =>
      _$ImageDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDTOToJson(this);
}

@JsonSerializable()
class OrderList {
  final List<Item> items;

  final double totalPoint;
  final int totalElements;
  final int totalItemExpired;
  final int totalItemReadyCheckout;

  const OrderList(
      {this.items,
      this.totalPoint,
      this.totalElements,
      this.totalItemExpired,
      this.totalItemReadyCheckout});

  factory OrderList.fromJson(Map<String, dynamic> json) =>
      _$OrderListFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListToJson(this);
}


@JsonSerializable()
class MyReward{
  final String voucherCode;
  final int quantity;
  final String startDate;
  final String expiryDate;
  final bool expired;
  final Item item;

  const MyReward(
      {this.voucherCode,
      this.quantity,
      this.startDate,
      this.expiryDate,
      this.expired,
      this.item});

  factory MyReward.fromJson(Map<String, dynamic> json) =>
      _$MyRewardFromJson(json);

  Map<String, dynamic> toJson() => _$MyRewardToJson(this);
}



@JsonSerializable()
class ListMyReward extends Pageable {
  final List<MyReward> content;
  final bool last;
  final int totalElements;

  ListMyReward({this.content, this.last, this.totalElements});

  factory ListMyReward.fromJson(Map<String, dynamic> json) =>
      _$ListMyRewardFromJson(json);
}
