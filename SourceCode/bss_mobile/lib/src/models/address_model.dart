import 'package:json_annotation/json_annotation.dart';
import 'package:bss_mobile/src/models/city_model.dart';
import 'package:bss_mobile/src/models/commune_model.dart';
import 'package:bss_mobile/src/models/district_model.dart';
import 'package:bss_mobile/src/models/stadium_model.dart';
part 'address_model.g.dart';

@JsonSerializable()
class Address {

  final int id;
  final String name;
  final City city;
  final String specificAddress;
  final String description;
  final District district;
  final Commune town;
  final List<Stadium> stadiumDTOs;


  Address({this.city,this.name,this.specificAddress,this.district,this.town,this.description,this.stadiumDTOs,this.id});

  
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}