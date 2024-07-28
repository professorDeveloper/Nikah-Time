import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart' as intl;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Chat/chat_class.dart';
import 'package:untitled/ServiceItems/network_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChatList>(_loadChatList);
    on<DeleteChat>(_deleteChat);
    on<SearchChat>(_searchChat);
  }

  String? accessToken;

  Future<void> getAccessToken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  void _loadChatList(LoadChatList event, Emitter<ChatState> emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }

    var response = await NetworkService().ChatsUser(accessToken!);

    if (response.statusCode != 200) {
      emit((state as ChatInitial).copyThis(
          pageState: PageState.error
      ));
      return;
    }

    List<dynamic> userChats = jsonDecode(response.body);
    List<ChatWithLastMessage> emptyChats = [];
    List<ChatWithLastMessage> allChatsList = [];
    for (int i = 0; i < userChats.length; i++) {
      ChatWithLastMessage newChat = ChatWithLastMessage();
      newChat.GetDataFromJson(userChats[i]);
      if (newChat.lastMessageTime == null) {
        emptyChats.add(newChat);
      } else {
        allChatsList.add(newChat);
      }
    }

    allChatsList.sort((a, b) {
      return intl.DateFormat('DD.MM.yyyy HH:mm:ss')
          .parse(b.lastMessageTime!)
          .compareTo(
          intl.DateFormat('DD.MM.yyyy HH:mm:ss').parse(a.lastMessageTime!));
    });
    allChatsList.addAll(emptyChats);

    emit((state as ChatInitial).copyThis(
      pageState: PageState.ready,
      allChatsList: allChatsList
    ));
  }

  void _deleteChat(DeleteChat event, Emitter<ChatState> emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }

    emit((state as ChatInitial).copyThis(
        pageState: PageState.loading
    ));

    try{
      NetworkService().chatsDeleteChatID(
        chatID: event.chatId
      );
    }catch(e){
      emit((state as ChatInitial).copyThis(
          pageState: PageState.error
      ));
      return;
    }

    List<ChatWithLastMessage> allChatsList = (state as ChatInitial).allChatsList;
    for (int i = 0; i < allChatsList.length; i++) {
      if (allChatsList[i].chatId == event.chatId) {
        allChatsList.removeAt(i);
        break;
      }
    }

    emit((state as ChatInitial).copyThis(
        pageState: PageState.ready,
        allChatsList: allChatsList
    ));
  }

  void _searchChat(SearchChat event, Emitter<ChatState> emit) async
  {
    List<ChatWithLastMessage> allChatsList = (state as ChatInitial).allChatsList;
    List<ChatWithLastMessage> searchedUser = [];
    for (int i = 0; i < allChatsList.length; i++) {
      if (allChatsList[i]
          .userName!
          .toLowerCase()
          .contains(event.searchString.toLowerCase())) {
        searchedUser.add(allChatsList[i]);
      }
    }

    emit((state as ChatInitial).copyThis(
        pageState: PageState.ready,
        searcedUser: searchedUser
    ));
  }

}
