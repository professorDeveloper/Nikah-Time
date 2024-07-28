part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}


class LoadChatList extends ChatEvent
{
  const LoadChatList();

  @override
  List<Object?> get props => [];
}


class DeleteChat extends ChatEvent
{
  final int chatId;

  const DeleteChat({required this.chatId});

  @override
  List<Object?> get props => [
    chatId
  ];
}


class SearchChat extends ChatEvent
{
  final String searchString;

  const SearchChat({required this.searchString});

  @override
  List<Object?> get props => [
    searchString
  ];
}