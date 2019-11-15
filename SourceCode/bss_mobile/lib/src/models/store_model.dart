import 'package:json_annotation/json_annotation.dart';
import 'package:bss_mobile/src/models/pageable_model.dart';

part 'store_model.g.dart';

@JsonSerializable()
class ListStore extends Pageable {
  final List<Store> content;
  final bool last;

  ListStore({this.content, this.last});

  factory ListStore.fromJson(Map<String, dynamic> json) => _$ListStoreFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoreToJson(this);
}


@JsonSerializable()
class Store {
  final String storeId;
  final String address;
  final String website;
  final String storeName;
  final String logoUrl;
  final String phone;
  final String description;
  double longitude;
  double latitude;
  final bool favourite;
  final int favouriteCount;
  Store(this.storeId, this.address, this.website, this.storeName, this.logoUrl, this.phone, this.description, this.favourite, this.favouriteCount);

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
