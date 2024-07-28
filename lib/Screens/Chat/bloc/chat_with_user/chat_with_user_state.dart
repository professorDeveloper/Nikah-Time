part of 'chat_with_user_bloc.dart';

abstract class ChatWithUserState extends Equatable {
  const ChatWithUserState();
}

enum PageState { hold, preload, loading, ready, error, noMoreItem, newMessage }

class ChatWithUserInitial extends ChatWithUserState {
  final PageState pageState;
  final List<ChatMessage> messages;
  final ChatWithLastMessage? chatData;
  final bool answerBoxVisible;
  final bool editBoxVisible;
  final String answerText;
  final String editText;
  const ChatWithUserInitial({
    this.pageState = PageState.preload,
    this.messages = const [],
    this.chatData,
    this.answerBoxVisible = false,
    this.editBoxVisible = false,
    this.answerText = '',
    this.editText = '',
    
  });

  ChatWithUserInitial copyThis({
    PageState? pageState,
    List<ChatMessage>? messages,
    ChatWithLastMessage? chatData,
    bool? answerBoxVisible,
    bool? editBoxVisible,
    String? answerText,
    String? editText,
  }) {
    return ChatWithUserInitial(
      pageState: pageState ?? this.pageState,
      messages: messages ?? this.messages,
      chatData: chatData ?? this.chatData,
      answerBoxVisible: answerBoxVisible ?? this.answerBoxVisible,
      editBoxVisible: editBoxVisible ?? this.editBoxVisible,
      answerText: answerText ?? this.answerText,
      editText: editText ?? this.editText,
    );
  }

  @override
  List<Object?> get props => [pageState, messages, chatData];
}
