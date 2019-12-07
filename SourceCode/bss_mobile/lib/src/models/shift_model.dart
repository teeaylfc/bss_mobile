import 'package:bss_mobile/src/models/address_model.dart';
import 'package:bss_mobile/src/models/stadium_model.dart';
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
  Address addressDTO;
  String date;
  Stadium stadiumDTO;
  Shift({this.id,this.shiftDTO,this.status,this.user,this.addressDTO,this.stadiumDTO,this.date});
  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}