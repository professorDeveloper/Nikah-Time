import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Chat/chat_class.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'chat_with_user_event.dart';
part 'chat_with_user_state.dart';

class ChatWithUserBloc extends Bloc<ChatWithUserEvent, ChatWithUserState> {
  ChatWithUserBloc({required ChatWithLastMessage chatData})
      : super(ChatWithUserInitial(chatData: chatData)) {
    on<LoadChatData>(_loadChatData);
    on<NewMessage>(_newMessage);
    on<ReadMessage>(_readMessage);
    on<BlockChat>(_blockChat);
    on<SendTextMessage>(_sendMessage);
    on<SendFile>(_sendFile);
    on<AsnwerChat>(answerChat);
    on<RemoveAnswerChat>(removeAnswerChat);
    on<EditChat>(editChat);
  }
  Future<void> answerChat(
      AsnwerChat answerChat, Emitter<ChatWithUserState> emit) async {
    emit((state as ChatWithUserInitial).copyThis(
      answerBoxVisible: true,
      answerText: answerChat.answerText,
      pageState: PageState.newMessage,
    ));
  }

  Future<void> editChat(
      EditChat editChat, Emitter<ChatWithUserState> emit) async {
    emit((state as ChatWithUserInitial).copyThis(
      editBoxVisible: true,
      editText: editChat.editText,
      pageState: PageState.newMessage,
    ));
  }

  Future<void> removeAnswerChat(
      RemoveAnswerChat answerChat, Emitter<ChatWithUserState> emit) async {
    emit((state as ChatWithUserInitial).copyThis(
      answerBoxVisible: false,
      editBoxVisible: false,
      answerText: '',
      pageState: PageState.hold,
    ));
  }



  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  void _loadChatData(
      LoadChatData event, Emitter<ChatWithUserState> emit) async {
    if (accessToken == null) {
      await getAccessToken();
    }

    List<ChatMessage> messages = [];
    int userId = 0;

    try {
      var response =
          await NetworkService().ChatsGetChatID(accessToken!, event.chatId);

      userId = jsonDecode(response.body)["chat"]["userId"];

      if (response.statusCode != 200) {
        throw Exception("Error on send");
      }

      //debugPrint("${response.body}");
      List<dynamic> receivedMessages = jsonDecode(response.body)["messages"];

      for (int i = 0; i < receivedMessages.length; i++) {
        ChatMessage message = ChatMessage();
        message.GetDataFromJson(receivedMessages[i]);
        if (message.isMessageSeen! == false &&
            message.isAuthUsermessage! == false) {
          NetworkService().ChatsSeenMessageID(accessToken!, message.messageId!);
        }
        messages.add(message);
      }

      MyTracker.trackEvent("Return to chat", {});
    } catch (err) {
      emit((state as ChatWithUserInitial).copyThis(
        pageState: PageState.error,
      ));
    }

    emit((state as ChatWithUserInitial).copyThis(
        chatData:
            (state as ChatWithUserInitial).chatData!.copyThis(userID: userId),
        pageState: PageState.ready,
        messages: messages.reversed.toList()));
  }

  void _newMessage(NewMessage event, Emitter<ChatWithUserState> emit) async {
    if (accessToken == null) {
      await getAccessToken();
    }

    List<ChatMessage> messages =
        (state as ChatWithUserInitial).messages.reversed.toList();
    ChatMessage message = ChatMessage();

    try {
      var response = await NetworkService()
          .ChatsGetMessageByID(accessToken!, event.messageId);

      if (response.statusCode != 200) {
        throw Exception("Error on send");
      }

      message.GetDataFromJson(jsonDecode(response.body));
      if (message.isAuthUsermessage == false) {
        response = await NetworkService()
            .ChatsSeenMessageID(accessToken!, event.messageId);
      }
    } catch (err) {
      emit((state as ChatWithUserInitial).copyThis(
        pageState: PageState.error,
      ));
      return;
    }

    messages.add(message);

    emit((state as ChatWithUserInitial).copyThis(
        pageState: PageState.ready, messages: messages.reversed.toList()));
  }

  void _readMessage(ReadMessage event, Emitter<ChatWithUserState> emit) async {
    if (accessToken == null) {
      await getAccessToken();
    }

    List<ChatMessage> messages =
        (state as ChatWithUserInitial).messages.reversed.toList();

    for (int i = messages.length - 1; i > 0; i--) {
      if (messages[i].isMessageSeen != true) {
        messages[i].isMessageSeen = true;
      } else {
        break;
      }
    }
    emit((state as ChatWithUserInitial).copyThis(
      pageState: PageState.loading,
    ));
    emit((state as ChatWithUserInitial).copyThis(
        pageState: PageState.ready, messages: messages.reversed.toList()));
  }

  void _blockChat(BlockChat event, Emitter<ChatWithUserState> emit) async {
    if (accessToken == null) {
      await getAccessToken();
    }

    try {
      // var response = await NetworkService().ChatsBlockChatID(
      //   accessToken!,
      //   (state as ChatWithUserInitial).chatData!.chatId!,
      // );

      // if (response.statusCode != 200) {
      //   throw Exception("Error on send");
      // }
      if ((state as ChatWithUserInitial).chatData!.isChatBlocked) {
        await NetworkService().unblockUser(
            userId: (state as ChatWithUserInitial).chatData!.userID!);
      } else {
        await NetworkService().blockUser(
            userId: (state as ChatWithUserInitial).chatData!.userID!);
      }
    } catch (err) {
      emit((state as ChatWithUserInitial).copyThis(
        pageState: PageState.error,
      ));
      return;
    }

    emit((state as ChatWithUserInitial).copyThis(
      chatData: (state as ChatWithUserInitial).chatData!.copyThis(
          isChatBlocked:
              (state as ChatWithUserInitial).chatData!.isChatBlocked == false),
      pageState: PageState.ready,
    ));
  }

  ChatMessage createMsg(
      {required String str,
      required String type,
      bool isMessageSend = false,
      bool sendedError = false}) {
    ChatMessage message = ChatMessage();

    message.message = str;
    DateTime dt = DateTime.now();
    dt = dt.add(const Duration(hours: 3) - DateTime.now().timeZoneOffset);
    message.messageTime = ''
        '${dt.day}.'
        '${dt.month}.'
        '${dt.year} '
        '${dt.hour}:'
        '${dt.minute}:'
        '${dt.second}';
    message.isAuthUsermessage = true;
    message.isMessageSeen = false;
    message.messageType = type;
    message.isMessageSend = isMessageSend;
    message.sendedError = sendedError;
    return message;
  }

  void _sendMessage(
      SendTextMessage event, Emitter<ChatWithUserState> emit) async {
    var text = event.text.trim();

    if (text.isEmpty) {
      return;
    }

    text = text.replaceAll(RegExp(r'((?<=\n)\s+)|((?<=\s)\s+)'), "");

    if (accessToken == null) {
      await getAccessToken();
    }

    List<ChatMessage> messages =
        (state as ChatWithUserInitial).messages.reversed.toList();
    messages.add(createMsg(str: text, type: "text"));

    emit((state as ChatWithUserInitial)
        .copyThis(messages: messages.reversed.toList()));

    try {
      var response = await NetworkService().ChatsSendMessage(accessToken!, text,
          (state as ChatWithUserInitial).chatData!.chatId!, "text");
      if (response.statusCode != 200) {
        throw Exception("Error on send");
      }
    } catch (err) {
      messages.removeLast();
      messages.add(createMsg(str: text, type: "text", sendedError: true));
      emit((state as ChatWithUserInitial)
          .copyThis(pageState: PageState.error, messages: messages));
      return;
    }

    messages.removeLast();
    messages.add(createMsg(str: text, type: "text", isMessageSend: true));

    emit((state as ChatWithUserInitial).copyThis(
        pageState: PageState.ready, messages: messages.reversed.toList()));
  }

  void _sendFile(SendFile event, Emitter<ChatWithUserState> emit) async {
    if (accessToken == null) {
      await getAccessToken();
    }

    // Prepare messages list
    List<ChatMessage> messages =
    (state as ChatWithUserInitial).messages.reversed.toList();
    messages.add(createMsg(str: event.file.path, type: event.fileType));

    // Emit loading state
    emit((state as ChatWithUserInitial).copyThis(
        pageState: PageState.loading, messages: messages.reversed.toList()));

    try {
      // Send file upload request
      var response = await NetworkService()
          .UploadFileRequest(accessToken!, event.file.path, event.fileType);

      // Check response status code
      if (response.statusCode != 200) {
        throw Exception('Failed to upload file: ${response.statusCode}');
      }

      // Collect the entire response body as a string
      final responseBody = await response.stream.bytesToString();

      // Debug print for response body
      print('Response body: $responseBody');

      // Decode the response body
      final valueMap = json.decode(responseBody);

      // Extract the file URL
      final url = valueMap["fileURL"];
      // Send message with the file URL
      await NetworkService().ChatsSendMessage(
          accessToken!, url.toString(),
          (state as ChatWithUserInitial).chatData!.chatId!, event.fileType);

      // Optional: Update messages list to reflect sent status
      messages.removeLast();
      messages.add(createMsg(str: url.toString(), type: event.fileType, isMessageSend: true));

      // Emit ready state with updated messages
      emit((state as ChatWithUserInitial).copyThis(
          pageState: PageState.ready,
          messages: messages.reversed.toList()));

      print("File URL: $url");

    } catch (error) {
      // Print and handle errors
      print('Error during file upload or JSON decoding: $error');

      // Emit error state
      emit((state as ChatWithUserInitial).copyThis(
        pageState: PageState.error,
      ));
    }
  }
}
