import 'package:json_annotation/json_annotation.dart';
import 'package:bss_mobile/src/models/item_model.dart';

part 'item_cms_model.g.dart';
@JsonSerializable()
class ItemCms {
  final List<Content> content;
  final bool last;
  final bool first;
  final bool empty;
  final int totalPages;
  final int totalElements;
  final int numberOfElements;
  final int size;
  final int number;

//  final int number;
  ItemCms(
      {this.content,
      this.last,
      this.first,
      this.empty,
      this.totalElements,
      this.totalPages,
      this.numberOfElements,
      this.size,
      this.number});
  factory ItemCms.fromJson(Map<String, dynamic> json) => _$ItemCmsFromJson(json);
  Map<String, dynamic> toJson() => _$ItemCmsToJson(this);
}

@JsonSerializable()
class Content {
  final String cmsId;
  final String contentType;
  final String bannerTitle;
  final DateTime startDate;
  final DateTime endDate;
  final String question;
  final String answer;
  final longDescription;
  final String textInButton;
  final String textColor;
  final String buttonColor;
  final String bannerUrl;
  final String description;
  final List<ImageDTO> imageDTOs;

  Content(
      {this.cmsId,
      this.contentType,
      this.bannerTitle,
      this.startDate,
      this.endDate,
      this.question,
      this.answer,
      this.longDescription,
      this.textInButton,
      this.textColor,
      this.buttonColor,
      this.bannerUrl,
      this.description,
      this.imageDTOs});
  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);
  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
