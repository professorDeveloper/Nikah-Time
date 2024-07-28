// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_chat_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedChatList _$PaginatedChatListFromJson(Map<String, dynamic> json) =>
    PaginatedChatList(
      chats: (json['data'] as List<dynamic>)
          .map((e) => ChatWithLastMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedChatListToJson(PaginatedChatList instance) =>
    <String, dynamic>{
      'data': instance.chats,
      'pagination': instance.pagination,
    };
