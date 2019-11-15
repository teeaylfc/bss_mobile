import 'package:json_annotation/json_annotation.dart';
import 'package:bss_mobile/src/models/commune_model.dart';
import 'package:bss_mobile/src/models/pageable_model.dart';

part 'district_model.g.dart';

@JsonSerializable()
class District extends Pageable {
  final String maqh;
  final String name;
  final String type;
  final List<Commune> townDTOs;
 District({this.maqh,this.name,this.type,this.townDTOs});
  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);
}