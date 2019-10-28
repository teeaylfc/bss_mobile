import 'package:json_annotation/json_annotation.dart';
import 'package:ols_mobile/src/models/shift_model.dart' ;

part 'stadium_model.g.dart';


@JsonSerializable()
class Stadium {
  final int id;
  final String name;
  final List<Shift> shiftDTOs;
  Stadium({this.id,this.name,this.shiftDTOs,});
  factory Stadium.fromJson(Map<String, dynamic> json) => _$StadiumFromJson(json);
}