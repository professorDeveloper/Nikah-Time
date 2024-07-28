// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChatResponse _$GetChatResponseFromJson(Map<String, dynamic> json) =>
    GetChatResponse(
      chat: Chat.fromJson(json['chat'] as Map<String, dynamic>),
      messages: PaginatedMessageList.fromJson(
          json['messages'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetChatResponseToJson(GetChatResponse instance) =>
    <String, dynamic>{
      'chat': instance.chat,
      'messages': instance.messages,
    };
