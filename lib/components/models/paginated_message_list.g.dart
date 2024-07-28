// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_message_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedMessageList _$PaginatedMessageListFromJson(
        Map<String, dynamic> json) =>
    PaginatedMessageList(
      messages: (json['data'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedMessageListToJson(
        PaginatedMessageList instance) =>
    <String, dynamic>{
      'data': instance.messages,
      'pagination': instance.pagination,
    };
