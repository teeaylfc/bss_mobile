import 'package:json_annotation/json_annotation.dart';
part 'shift_dto_model.g.dart';

@JsonSerializable()
class ShiftDTO {
  final int id;
  final int name;
  final double cash;  
  ShiftDTO({this.id,this.name,this.cash});
  factory ShiftDTO.fromJson(Map<String, dynamic> json) => _$ShiftDTOFromJson(json);
}