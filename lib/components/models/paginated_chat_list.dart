import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/Screens/Chat/chat_class.dart';
import 'package:untitled/components/models/pagination.dart';

part 'paginated_chat_list.g.dart';

@JsonSerializable()
class PaginatedChatList {
  @JsonKey(name: "data")
  final List<ChatWithLastMessage> chats;

  final Pagination pagination;

  PaginatedChatList({required this.chats, required this.pagination});

  factory PaginatedChatList.fromJson(Map<String, dynamic> json) => _$PaginatedChatListFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedChatListToJson(this);
}