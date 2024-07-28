import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/components/models/paginated_message_list.dart';

import '../../Screens/Chat/chat_class.dart';

part 'get_chat_response.g.dart';

@JsonSerializable()
class GetChatResponse {
  final Chat chat;
  final PaginatedMessageList messages;

  GetChatResponse({required this.chat, required this.messages});

  factory GetChatResponse.fromJson(Map<String, dynamic> json) => _$GetChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetChatResponseToJson(this);
}