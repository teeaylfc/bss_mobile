import 'package:json_annotation/json_annotation.dart';
import 'package:ols_mobile/src/models/stadium_model.dart';

part 'list_stadium_model.g.dart';


@JsonSerializable()
class ListStadium {
  final List<Stadium> address;
  ListStadium({this.address});
  factory ListStadium.fromJson(Map<String, dynamic> json) => _$ListStadiumFromJson(json);
}