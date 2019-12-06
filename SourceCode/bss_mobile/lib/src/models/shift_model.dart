import 'package:json_annotation/json_annotation.dart';
import 'package:bss_mobile/src/models/account_info_model.dart';
import 'package:bss_mobile/src/models/shift_dto_model.dart';
part 'shift_model.g.dart';

@JsonSerializable()
class Shift {
  final int id;
  final int status; 
  ShiftDTO shiftDTO;
  AccountInfo user;
  Shift({this.id,this.shiftDTO,this.status,this.user});
  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}