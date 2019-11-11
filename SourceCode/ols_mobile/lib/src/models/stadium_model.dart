import 'package:json_annotation/json_annotation.dart';
import 'package:ols_mobile/src/models/shift_model.dart' ;

part 'stadium_model.g.dart';


@JsonSerializable()
class Stadium {
  final int id;
  final int maType;
  final String name;
  final String description;
  final List<Shift> statusShiftResponses;
  Stadium({this.id,this.maType,this.name,this.statusShiftResponses,this.description});
  factory Stadium.fromJson(Map<String, dynamic> json) => _$StadiumFromJson(json);
}