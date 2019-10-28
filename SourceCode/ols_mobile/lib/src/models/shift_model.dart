import 'package:json_annotation/json_annotation.dart';
part 'shift_model.g.dart';

@JsonSerializable()
class Shift {
  final int id;
  final String name;
  final String time;
  final double cash;  
  Shift({this.id,this.name,this.time,this.cash});
  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}