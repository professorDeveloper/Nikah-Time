part of 'chat_with_user_bloc.dart';

abstract class ChatWithUserEvent extends Equatable {
  const ChatWithUserEvent();
}

class LoadChatData extends ChatWithUserEvent {
  final int chatId;

  const LoadChatData({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class NewMessage extends ChatWithUserEvent {
  final int messageId;

  const NewMessage({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class ReadMessage extends ChatWithUserEvent {
  const ReadMessage();

  @override
  List<Object?> get props => [];
}

class BlockChat extends ChatWithUserEvent {
  const BlockChat();

  @override
  List<Object?> get props => [];
}

class SendTextMessage extends ChatWithUserEvent {
  final String text;

  const SendTextMessage({required this.text});

  @override
  List<Object?> get props => [
        text,
      ];
}

class SendFile extends ChatWithUserEvent {
  final File file;
  final String fileType;

  const SendFile({required this.file, required this.fileType});

  @override
  List<Object?> get props => [file, fileType];
}

class AsnwerChat extends ChatWithUserEvent {
  final String answerText;
  const AsnwerChat({
    required this.answerText,
  });
  @override
  List<Object?> get props => [answerText];
}

class EditChat extends ChatWithUserEvent {
  final String editText;
  const EditChat({
    required this.editText,
  });
  @override
  List<Object?> get props => [editText];
}

class RemoveAnswerChat extends ChatWithUserEvent {
  const RemoveAnswerChat();
  @override
  List<Object?> get props => [];
}

