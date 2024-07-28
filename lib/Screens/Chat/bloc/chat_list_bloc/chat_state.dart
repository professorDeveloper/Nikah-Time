part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

enum PageState
{
  hold,
  preload,
  loading,
  ready,
  error,
  noMoreItem
}

class ChatInitial extends ChatState {
  final PageState pageState;

  final List<ChatWithLastMessage> allChatsList;
  final List<ChatWithLastMessage> searcedUser;


  const ChatInitial({
    this.pageState = PageState.preload,
    this.allChatsList = const [],
    this.searcedUser = const [],
  });

  ChatInitial copyThis({
    PageState? pageState,
    List<ChatWithLastMessage>? allChatsList,
    List<ChatWithLastMessage>? searcedUser,
  })
  {
    return ChatInitial(
      allChatsList : allChatsList ?? this.allChatsList,
      searcedUser : searcedUser ?? this.searcedUser,
      pageState : pageState ?? this.pageState
    );
  }

  @override
  List<Object> get props => [
    pageState,

    allChatsList,
    searcedUser,
  ];
}
