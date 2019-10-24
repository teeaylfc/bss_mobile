import 'package:json_annotation/json_annotation.dart';
import 'package:ols_mobile/src/models/pageable_model.dart';

part 'city_model.g.dart';

@JsonSerializable()
class City extends Pageable {
  final String matp;
  final String name;
  final String type;
 City({this.matp,this.name,this.type});
  factory City.fromJson(Map<String, dynamic> json) =>
      _$CityFromJson(json);
}
