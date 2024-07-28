// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nikah_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NikahError _$NikahErrorFromJson(Map<String, dynamic> json) => NikahError(
      code: json['code'] as int,
      title: json['title'] as String,
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$NikahErrorToJson(NikahError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'detail': instance.detail,
    };
