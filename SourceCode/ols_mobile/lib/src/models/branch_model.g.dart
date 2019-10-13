// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListBranch _$ListBranchFromJson(Map<String, dynamic> json) {
  return ListBranch(
      content: (json['content'] as List)
          ?.map((e) =>
              e == null ? null : Branch.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      last: json['last'] as bool);
}

Map<String, dynamic> _$ListBranchToJson(ListBranch instance) =>
    <String, dynamic>{'content': instance.content, 'last': instance.last};

Branch _$BranchFromJson(Map<String, dynamic> json) {
  return Branch(
      branchId: json['branchId'] as String,
      branchName: json['branchName'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
      logoUrl: json['logoUrl'] as String,
      website: json['website'] as String,
      favourite: json['favourite'] as bool,
      favouriteCount: json['favouriteCount'] as int);
}

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'address': instance.address,
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'website': instance.website,
      'favourite': instance.favourite,
      'favouriteCount': instance.favouriteCount
    };
