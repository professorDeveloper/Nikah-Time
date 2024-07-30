import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:menu_bar/menu_bar.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/Screens/Chat/bloc/chat_with_user/chat_with_user_bloc.dart';
import 'package:untitled/components/widgets/image_viewer.dart';
import 'package:untitled/components/widgets/send_claim.dart';

import 'package:laravel_echo2/laravel_echo2.dart';
import 'package:untitled/Screens/Chat/chat_class.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';

import '../../components/network_service/dio_override/dio_service_additions.dart';

class ChatWithUserScreen extends StatefulWidget {
  ChatWithUserScreen(this.chatData, this.userProfileGender, this.userProfileId,
      {super.key}) {
    bloc = ChatWithUserBloc(chatData: chatData);
  }

  ChatWithLastMessage chatData;
  final String userProfileGender;
  final int userProfileId;
  late ChatWithUserBloc bloc;

  @override
  State<ChatWithUserScreen> createState() => _ChatWithUserScreenState();
}

class _ChatWithUserScreenState extends State<ChatWithUserScreen> {
  TextEditingController messageController = TextEditingController();
  final ScrollController _myController = ScrollController();
  late Echo echo_message;
  int lastMsgNmb = 0;

  connectToSocket() async {
    debugPrint("Try to server connect");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token") ?? "";
    try {
      echo_message = Echo({
        'broadcaster': 'socket.io',
        'host': 'https://www.nikahtime.ru:6002',
        'auth': {
          'headers': {'Authorization': 'Bearer $accessToken'}
        }
      });
      echo_message
          .private('chats.${prefs.getInt("userId") ?? ""}')!
          .listen("NewChatMessage", (e) => {SocketEvent(e)});
      //echo_message.connector.socket!
      //    .onConnect((_) => print('connected from chatlist'));
      //echo_message.connector.socket!.onDisconnect((_) => print('disconnected'));
    } catch (e) {
      //print(e.toString());
      return;
    }
  }

  void SocketEvent(dynamic e) {
    if (mounted == false) {
      return;
    }
    debugPrint("LastMsg $lastMsgNmb, messageId ${e["messageId"]}");
    if (e["chatId"] == null || e["chatId"] != widget.chatData.chatId) {
      return;
    }
    if (e["type"] == "Новое сообщение") {
      lastMsgNmb = e["messageId"];
      widget.bloc.add(NewMessage(messageId: lastMsgNmb));
    }
    if (e["type"] == "Прочитано") {
      debugPrint("aedaedaed");

      widget.bloc.add(const ReadMessage());
    }
  }

  @override
  void initState() {
    connectToSocket();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.chatData);
    print(widget.userProfileGender);
    print(widget.userProfileId);
    return BlocProvider.value(
      value: widget.bloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: header(context, (widget.bloc.state as ChatWithUserInitial)),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<ChatWithUserBloc, ChatWithUserState>(
                bloc: widget.bloc,
                builder: (context, state) {
                  return body(context, state);
                },
              )),
        ),
      ),
    );
  }

  Widget waitBox() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Color.fromRGBO(0, 0xcf, 0x91, 1)),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            LocaleKeys.chat_waitbox.tr(),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: const Color.fromRGBO(0, 0xcf, 0x91, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget header(BuildContext context, ChatWithUserInitial state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: const Color.fromARGB(255, 218, 216, 215),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              ),
              child: IconButton(
                  iconSize: 18.0,
                  icon: const Icon(Icons.arrow_back_ios_sharp),
                  onPressed: () {
                    Navigator.pop(context,
                        (widget.bloc.state as ChatWithUserInitial).chatData);
                  }),
            ),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
                onTap: () async {
                  UserProfileData targetUserProfile = UserProfileData();

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String accessToken = prefs.getString("token") ?? "";

                  var response = await NetworkService().GetUserInfoByID(
                      accessToken,
                      (widget.bloc.state as ChatWithUserInitial)
                          .chatData!
                          .userID!);

                  if (response.statusCode != 200) {
                    return;
                  }
                  debugPrint("${response.statusCode}");
                  debugPrint("${jsonDecode(response.body)}");
                  targetUserProfile.jsonToData(jsonDecode(response.body)[0]);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SingleUser(anketa: targetUserProfile),
                      )).then((_) => {setState(() {})});
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 8,
                  height: MediaQuery.of(context).size.width / 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90.0),
                    child: displayImageMiniature(
                        widget.chatData.avatar?.preview ?? ""),
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.chatData.userName.toString(),
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color.fromARGB(255, 33, 33, 33),
                    ),
                  ),
                ),
                (widget.chatData.isOnline == false)
                    ? ((widget.chatData.lastTimeOnline != null)
                        ? Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              LocaleKeys.chat_main_lastTimeOnline_prefix.tr() +
                                  getTimeValue(widget.chatData.lastTimeOnline
                                      .toString()) +
                                  LocaleKeys.chat_main_lastTimeOnline_postfix
                                      .tr(),
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: const Color.fromARGB(255, 157, 157, 157),
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              LocaleKeys.common_offline.tr(),
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: const Color.fromARGB(255, 157, 157, 157),
                              ),
                            ),
                          ))
                    : Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          LocaleKeys.common_online.tr(),
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: const Color.fromARGB(255, 157, 157, 157),
                          ),
                        ),
                      ),
              ],
            )
          ],
        ),
        moreButton(context, state)
      ],
    );
  }

  Widget blockedBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Text(
            LocaleKeys.chat_blocked.tr(),
          ))
        ],
      ),
    );
  }

  Widget inputBox() {
    return Row(
      children: [

        Expanded(
          flex: 1,
          child: Container(
              height: 54,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: const Color.fromARGB(255, 218, 216, 215),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: IconButton(
                splashRadius: 1,
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.attach_file_outlined,
                  color: Color.fromARGB(255, 150, 150, 150),
                ),
                onPressed: () {
                  filePicker();
                },
              )),
        ),
        const SizedBox(
          width: 5,
        ),

        Expanded(
            flex: 7,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    widget.bloc
                        .add(SendTextMessage(text: messageController.text));
                    messageController.text = "";
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: const Icon(Icons.send),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 218, 216, 215),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 0, 207, 145),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              controller: messageController,
            )),
        const SizedBox(
          width: 5,
        ),

        Expanded(
          flex: 1,
          child: Container(
              height: 54,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: const Color.fromARGB(255, 218, 216, 215),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              ),
              child: IconButton(
                splashRadius: 1,
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.mic,
                  color: Color.fromARGB(255, 150, 150, 150),
                ),
                onPressed: () {
                },
              )),
        ),

      ],
    );
  }

  Widget body(BuildContext context, ChatWithUserState state) {
    state as ChatWithUserInitial;
    if (state.pageState == PageState.preload) {
      widget.bloc.add(LoadChatData(chatId: widget.chatData.chatId!));
      return waitBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: chatListVisualBuilder(context, state)),
        if (state.answerBoxVisible || state.editBoxVisible)
          Row(
            children: [
              Image.asset(
                'assets/icons/bxs_share.png',
                width: 15,
                height: 13,
                color: const Color(
                  0xff212121,
                ).withOpacity(0.3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Text(
                  'В ответ на:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(
                      0xff212121,
                    ).withOpacity(0.3),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  state.answerBoxVisible ? state.answerText : state.editText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: (state.chatData!.isChatBlocked != true)
              ? inputBox()
              : blockedBox(),
        )
      ],
    );
  }

  Widget chatListVisualBuilder(
      BuildContext context, ChatWithUserInitial state) {
    Widget list = ListView.separated(
      reverse: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (BuildContext context, int index) {
        return chatListItem(state, index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 8,
        );
      },
      itemCount: state.messages.length,
      controller: _myController,
    );

    Timer(const Duration(),
        () => _myController.jumpTo(_myController.position.minScrollExtent));

    return list;
  }

  Widget chatListItem(ChatWithUserInitial state, int index) {
    CustomPopupMenuController controller = CustomPopupMenuController();
    ChatMessage message = state.messages[index];
    return Column(
      children: [
        dateDivider(message, index, state.messages.length - 1),
        Align(
          alignment: message.isAuthUsermessage! == false
              ? Alignment.topLeft
              : Alignment.topRight,
          child: CustomPopupMenu(
            horizontalMargin: 16,
            verticalMargin: 10,
            menuBuilder: () {
              widget.bloc.add(
                const RemoveAnswerChat(),
              );
              return Container(
                padding: const EdgeInsets.all(
                  15,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10,
                    )),
                width: 190,
                height: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (message.message != null) {
                            widget.bloc.add(
                              AsnwerChat(
                                answerText: message.message!,
                              ),
                            );
                            controller.hideMenu();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Ответить',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff212121),
                              ),
                            ),
                            Image.asset(
                              'assets/icons/bxs_share.png',
                              width: 22,
                              height: 22,
                              color: const Color(
                                0xff212121,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          String messageText = (message.message!).toString();
                          Clipboard.setData(ClipboardData(text: messageText));
                          controller.hideMenu();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Копировать',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff212121),
                              ),
                            ),
                            Image.asset(
                              'assets/icons/bxs_copy.png',
                              width: 22,
                              height: 22,
                              color: const Color(
                                0xff212121,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (message.message != null) {
                            widget.bloc.add(
                              EditChat(
                                editText: message.message!,
                              ),
                            );
                            controller.hideMenu();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Изменить',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff212121),
                              ),
                            ),
                            Image.asset(
                              'assets/icons/bxs_pencil.png',
                              width: 22,
                              height: 22,
                              color: const Color(
                                0xff212121,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteMessage(state.messages[index].messageId!);
                        setState(() {
                          state.messages.removeAt(index);
                        });
                        controller.hideMenu();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Удалить',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffFC3B3B),
                            ),
                          ),
                          Image.asset(
                            'assets/icons/bxs_trash.png',
                            width: 22,
                            height: 22,
                            color: const Color(
                              0xffFC3B3B,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            controller: controller,
            barrierColor: Colors.transparent,
            showArrow: false,
            pressType: PressType.longPress,
            child: Container(
              margin: EdgeInsets.only(
                left: message.isAuthUsermessage! == false
                    ? 0
                    : MediaQuery.of(context).size.width / 5 + 16,
                right: message.isAuthUsermessage! == true
                    ? 0
                    : MediaQuery.of(context).size.width / 5 + 16,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (message.isAuthUsermessage!)
                    ? const Color.fromARGB(255, 235, 235, 235)
                    : const Color.fromARGB(255, 227, 241, 237),
                borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(10),
                    topLeft: const Radius.circular(10),
                    bottomLeft:
                        Radius.circular((message.isAuthUsermessage!) ? 10 : 0),
                    bottomRight:
                        Radius.circular((message.isAuthUsermessage!) ? 0 : 10)),
              ),
              child: Column(
                crossAxisAlignment: (message.isAuthUsermessage!)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                //spacing: 8,
                children: [
                  messageBody(message),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          intl.DateFormat('HH:mm').format(
                              intl.DateFormat('DD.MM.yyyy HH:mm:ss')
                                  .parse(message.messageTime!)
                                  .add(DateTime.now().timeZoneOffset -
                                      const Duration(hours: 3))),
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        Visibility(
                            visible: message.isAuthUsermessage == true,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 2,
                                ),
                                Container(child: messageStatusMark(message)),
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> deleteMessage(int messageId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token") ?? "";
    String csrfToken = "LHXZTMpSzw8TCVkXqAO6LFG41B4cN1Oth80CvX7J";

    if (accessToken.isEmpty) {
      debugPrint("Token not found.");
      return;
    }

    Dio dio = Dio();
    try {
      Response response = await dio.delete(
        'https://www.nikahtime.ru/api/chats/message/$messageId/delete',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRF-TOKEN': csrfToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Message deleted successfully');
      } else {
        debugPrint('Failed to delete message: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error deleting message: $e');
    }
  }

  Widget messageStatusMark(ChatMessage message) {
    List<Widget> children = [
      Icon(
        Icons.check,
        size: 18,
        color: (message.isMessageSeen == true)
            ? const Color.fromRGBO(0, 0xcf, 0x91, 1)
            : Colors.grey,
      )
    ];
    if (message.isMessageSeen == true) {
      children.add(const Positioned(
          top: 0,
          left: 4,
          child: Icon(
            Icons.check,
            size: 18,
            color: Color.fromRGBO(0, 0xcf, 0x91, 1),
          )));
    }

    return Stack(
      clipBehavior: Clip.none,
      children: children,
    );
  }

  DateTime convertData(String date) {
    return intl.DateFormat('DD.MM.yyyy HH:mm:ss').parse(date);
  }

  Widget dateDivider(ChatMessage message, int index, int maxSize) {
    DateTime currDate = convertData(message.messageTime!);
    DateTime lastDate = currDate;

    if (index == maxSize) {
      lastDate = convertData((widget.bloc.state as ChatWithUserInitial)
          .messages[index]
          .messageTime!);
    } else {
      lastDate = convertData((widget.bloc.state as ChatWithUserInitial)
          .messages[index + 1]
          .messageTime!);
    }

    if (index != maxSize &&
        (lastDate.day == currDate.day &&
            lastDate.month == currDate.month &&
            lastDate.year == currDate.year)) {
      return const SizedBox(height: 0);
    }

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(children: <Widget>[
          const Expanded(child: Divider()),
          Text(
            "${currDate.day}.${currDate.month}.${currDate.year}",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const Expanded(child: Divider()),
        ]),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget messageBody(ChatMessage message) {
    if (message.messageType == "text") {
      return Text(
        message.message!,
      );
    }
    if (message.messageType == "image") {
      return SizedBox(
        height: 300,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: displayPhotoOrVideo(context, message.message!.toString(),
                initPage: 0,
                items: <String>[message.message!.toString()],
                photoOwnerId: (widget.bloc.state as ChatWithUserInitial)
                        .chatData
                        ?.userID ??
                    0)),
      );
    }
    if (message.messageType == "file") {
      String idStr =
          message.message!.substring(message.message!.lastIndexOf('/') + 1);
      //debugPrint(idStr);
      if (idStr.contains(".mp4") ||
          idStr.contains(".avi") ||
          idStr.contains(".mov")) {
        /*return GestureDetector(
            onTap: () {
              try{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      message.message!,
                      photoOwnerId: (widget.bloc.state as ChatWithUserInitial).chatData?.userID ?? 0
                    ),
                  )
                );
              }catch(e){
                debugPrint(e.toString());
              }

            },
            child: Row(
              children: [
                const Icon(
                  Icons.videocam,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                    LocaleKeys.chat_video.tr() +
                        "${p.extension(message.message!)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.blue.shade500,
                      //decoration: TextDecoration.underline,
                    )),
              ],
            ));*/
        return Column(
          children: [
            SizedBox(
              height: 64,
              width: 64,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: displayPhotoOrVideo(
                      context, message.message!.toString(),
                      initPage: 0,
                      items: <String>[message.message!.toString()],
                      photoOwnerId: (widget.bloc.state as ChatWithUserInitial)
                              .chatData
                              ?.userID ??
                          0)),
            ),
            Row(
              children: [
                const Icon(
                  Icons.videocam,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(LocaleKeys.chat_video.tr() + p.extension(message.message!),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.blue.shade500,
                      //decoration: TextDecoration.underline,
                    )),
              ],
            )
          ],
        );
      }
      return GestureDetector(
          onTap: () => setState(() {
                try {
                  _launchInBrowser(message.message!);
                } catch (err) {
                  //print(err.toString());
                }
              }),
          child: Row(
            children: [
              const Icon(
                Icons.insert_drive_file_rounded,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(LocaleKeys.chat_file.tr() + p.extension(message.message!),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.blue.shade500,
                    //decoration: TextDecoration.underline,
                  )),
            ],
          ));
    }

    return const Text("Ошибка загрузки сообщения");
  }

  Future<void> _launchInBrowser(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    /*if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );

    } else {
      throw 'Could not launch $url';
    }*/
  }

  filePicker() {
    ImagePicker picker = ImagePicker();
    return showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: Text(LocaleKeys.chat_bottom_img_take.tr()),
          onTap: () async {
            XFile? image = await picker.pickImage(
                source: ImageSource.camera,
                preferredCameraDevice: CameraDevice.front);
            Navigator.pop(context);
            widget.bloc
                .add(SendFile(file: File(image!.path), fileType: "image"));
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_album),
          title: Text(LocaleKeys.chat_bottom_img_get.tr()),
          onTap: () async {
            XFile? image = await picker.pickImage(
              source: ImageSource.gallery,
            );
            Navigator.pop(context);
            widget.bloc
                .add(SendFile(file: File(image!.path), fileType: "image"));
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: Text(LocaleKeys.chat_bottom_video_take.tr()),
          onTap: () async {
            XFile? video = await picker.pickVideo(source: ImageSource.camera);
            Navigator.pop(context);
            if (video != null) {
              widget.bloc
                  .add(SendFile(file: File(video.path), fileType: "file"));
            } else {
              print('Video picking canceled');
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.video_library),
          title: Text(LocaleKeys.chat_bottom_video_get.tr()),
          onTap: () async {
            XFile? video = await picker.pickVideo(
              source: ImageSource.gallery,
            );
            debugPrint(video!.path);
            Navigator.pop(context);
            widget.bloc.add(SendFile(file: File(video.path), fileType: "file"));
          },
        ),
        ListTile(
          leading: const Icon(Icons.insert_drive_file),
          title: Text(LocaleKeys.chat_bottom_file.tr()),
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              File file = File(result.files.single.path!);
              debugPrint(result.files.single.path!);
              widget.bloc.add(SendFile(file: file, fileType: "file"));
            } else {
              // User canceled the picker
            }

            Navigator.pop(context);
          },
        ),
      ]),
    );
  }

  Widget moreButton(BuildContext context, ChatWithUserInitial state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: const Color.fromARGB(255, 218, 216, 215),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      ),
      child: PopupMenuButton(
          offset: const Offset(0, 50),
          shape: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          itemBuilder: (itemContext) {
            List<PopupMenuEntry> items = [];
            if ((state.chatData!.isChatBlocked &&
                    state.chatData!.isAuthUserBlockChat) ||
                state.chatData!.isChatBlocked == false) {
              items.add(
                PopupMenuItem(
                  onTap: () async {
                    widget.bloc.add(const BlockChat());
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.lock),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Container(
                        child: ((widget.bloc.state as ChatWithUserInitial)
                                .chatData!
                                .isChatBlocked)
                            ? Text(LocaleKeys.chat_unblock.tr())
                            : Text(LocaleKeys.chat_block.tr()),
                      ))
                    ],
                  ),
                ),
              );
            }
            items.addAll([
              PopupMenuItem(
                onTap: () async {
                  await NetworkService()
                      .chatsDeleteChatID(chatID: widget.chatData.chatId!);
                  Navigator.pop(this.context);
                },
                child: Row(
                  children: [
                    const Icon(Icons.delete),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      LocaleKeys.chat_delete.tr(),
                    )
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  Future.delayed(
                      const Duration(seconds: 0),
                      () => SendClaim(
                              claimObjectId:
                                  (widget.bloc.state as ChatWithUserInitial)
                                          .chatData
                                          ?.userID ??
                                      0,
                              type: ClaimType.photo)
                          .ShowAlertDialog(context));
                },
                child: Row(
                  children: [
                    const Icon(Icons.block),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      LocaleKeys.chat_report.tr(),
                    )
                  ],
                ),
              ),
            ]);
            return items;
          }),
    );
  }

  String getTimeValue(String str) {
    DateTime messageDt;
    try {
      messageDt = intl.DateFormat('DD.MM.yyyy HH:mm:ss').parse(str);
      debugPrint(DateTime.now().timeZoneOffset.toString());

      Duration defaultOffset = const Duration(hours: 3);

      messageDt = messageDt.add(DateTime.now().timeZoneOffset - defaultOffset);
    } catch (on) {
      return "";
    }
    String timeValue = "";

    int value = DateTime.now().difference(messageDt).inMinutes.abs();
    timeValue = LocaleKeys.chat_main_min.tr();
    if (value > 59) {
      timeValue = LocaleKeys.chat_main_hour.tr();
      value = DateTime.now().difference(messageDt).inHours.abs();
      if (value > 24) {
        timeValue = LocaleKeys.chat_main_day.tr();
        value = DateTime.now().difference(messageDt).inDays.abs();
      }
    }
    String result;
    if (value == 0) {
      result = LocaleKeys.chat_main_now.tr();
    } else {
      result = "$value $timeValue";
    }

    return result;
  }
}
