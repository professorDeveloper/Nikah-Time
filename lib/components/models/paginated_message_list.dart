import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/Screens/Chat/chat_class.dart';
import 'package:untitled/components/models/pagination.dart';

part 'paginated_message_list.g.dart';

@JsonSerializable()
class PaginatedMessageList {
  @JsonKey(name: "data")
  final List<ChatMessage> messages;

  final Pagination pagination;

  PaginatedMessageList({required this.messages, required this.pagination});

  factory PaginatedMessageList.fromJson(Map<String, dynamic> json) => _$PaginatedMessageListFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedMessageListToJson(this);
}