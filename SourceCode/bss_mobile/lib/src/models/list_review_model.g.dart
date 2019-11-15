// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListReview _$ListReviewFromJson(Map<String, dynamic> json) {
  return ListReview(
      content: (json['content'] as List)
          ?.map((e) =>
              e == null ? null : Review.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      last: json['last'] as bool,
      totalElements: json['totalElements'] as int);
}

Map<String, dynamic> _$ListReviewToJson(ListReview instance) =>
    <String, dynamic>{
      'content': instance.content,
      'last': instance.last,
      'totalElements': instance.totalElements
    };
