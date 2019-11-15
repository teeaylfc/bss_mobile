import 'package:json_annotation/json_annotation.dart';
import 'package:bss_mobile/src/models/pageable_model.dart';

part 'commune_model.g.dart';

@JsonSerializable()
class Commune extends Pageable {
  final String  xaid;
  final String name;
  final String type;
 Commune({this.xaid,this.name,this.type});
  factory Commune.fromJson(Map<String, dynamic> json) =>
      _$CommuneFromJson(json);
}
