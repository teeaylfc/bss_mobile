import 'package:json_annotation/json_annotation.dart';
import 'package:bss_mobile/src/models/pageable_model.dart';

part 'branch_model.g.dart';

@JsonSerializable()
class ListBranch extends Pageable {
  final List<Branch> content;
  final bool last;

  ListBranch({this.content, this.last});

  factory ListBranch.fromJson(Map<String, dynamic> json) => _$ListBranchFromJson(json);
}

@JsonSerializable()
class Branch {
  final String branchId;
  final String branchName;
  final String address;
  final String description;
  final String logoUrl;
  final String website;
  final bool favourite;
  final int favouriteCount;
  Branch({this.branchId, this.branchName, this.address, this.description, this.logoUrl, this.website, this.favourite, this.favouriteCount});

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}
