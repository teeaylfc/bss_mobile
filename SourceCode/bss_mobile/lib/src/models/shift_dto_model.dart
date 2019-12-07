import 'package:json_annotation/json_annotation.dart';
part 'shift_dto_model.g.dart';

@JsonSerializable()
class ShiftDTO {
  final int id;
  final int name;
  final double cash;  
 final String time_start;
 final String time_end; 
  ShiftDTO({this.id,this.time_start,this.time_end,this.name,this.cash});
  factory ShiftDTO.fromJson(Map<String, dynamic> json) => _$ShiftDTOFromJson(json);
}