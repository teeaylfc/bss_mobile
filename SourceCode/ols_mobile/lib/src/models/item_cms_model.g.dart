// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_cms_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemCms _$ItemCmsFromJson(Map<String, dynamic> json) {
  return ItemCms(
      content: (json['content'] as List)
          ?.map((e) =>
              e == null ? null : Content.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      last: json['last'] as bool,
      first: json['first'] as bool,
      empty: json['empty'] as bool,
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      numberOfElements: json['numberOfElements'] as int,
      size: json['size'] as int,
      number: json['number'] as int);
}

Map<String, dynamic> _$ItemCmsToJson(ItemCms instance) => <String, dynamic>{
      'content': instance.content,
      'last': instance.last,
      'first': instance.first,
      'empty': instance.empty,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'numberOfElements': instance.numberOfElements,
      'size': instance.size,
      'number': instance.number
    };

Content _$ContentFromJson(Map<String, dynamic> json) {
  return Content(
      cmsId: json['cmsId'] as String,
      contentType: json['contentType'] as String,
      bannerTitle: json['bannerTitle'] as String,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      question: json['question'] as String,
      answer: json['answer'] as String,
      longDescription: json['longDescription'],
      textInButton: json['textInButton'] as String,
      textColor: json['textColor'] as String,
      buttonColor: json['buttonColor'] as String,
      bannerUrl: json['bannerUrl'] as String,
      description: json['description'] as String,
      imageDTOs: (json['imageDTOs'] as List)
          ?.map((e) =>
              e == null ? null : ImageDTO.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'cmsId': instance.cmsId,
      'contentType': instance.contentType,
      'bannerTitle': instance.bannerTitle,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'question': instance.question,
      'answer': instance.answer,
      'longDescription': instance.longDescription,
      'textInButton': instance.textInButton,
      'textColor': instance.textColor,
      'buttonColor': instance.buttonColor,
      'bannerUrl': instance.bannerUrl,
      'description': instance.description,
      'imageDTOs': instance.imageDTOs
    };
