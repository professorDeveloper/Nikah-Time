import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/models/email_notification.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';

part 'chat_settings_event.dart';
part 'chat_settings_state.dart';

class ChatSettingsBloc extends Bloc<ChatSettingsEvent, ChatSettingsState> {
  ChatSettingsBloc() : super(ChatSettingsInitial())
  {
    on<InputAction>(_onInputAction);
    on<LoadProfileInfo>(_onLoadProfileInfo);
    on<NotificationAction>(_onNotificationAction);
  }

  void _onInputAction(InputAction event, Emitter emit)
  {
    emit((state as ChatSettingsInitial).copyThis(
      emailError: "",
    ));

    String err = '';

    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(event.data))
    {
      err = LocaleKeys.paymentScreen_emailForReceiptError_emailInvalid.tr();
    }

    emit((state as ChatSettingsInitial).copyThis(
      email: event.data,
      emailError: err,
    ));
  }

  Future<void> _onLoadProfileInfo(LoadProfileInfo event, Emitter emit) async
  {
    UserProfileData profile = UserProfileData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await NetworkService()
          .GetUserInfo(prefs.getString("token").toString());

      if (response.statusCode != 200) {
        emit((state as ChatSettingsInitial).copyThis(
          screenState: ScreenState.error,
        ));
        return;
      }
      profile.jsonToData(jsonDecode(response.body)[0]);
      profile.accessToken = prefs.getString("token").toString();
    } catch (e) {
      emit((state as ChatSettingsInitial).copyThis(
        screenState: ScreenState.error,
      ));
      return;
    }

    emit((state as ChatSettingsInitial).copyThis(
      userData: profile,
      email: profile.emailNotification.email,
      notifyEnable: profile.emailNotification.isEnabled,
      screenState: ScreenState.ready,
    ));
  }

  Future<void> _onNotificationAction(NotificationAction event, Emitter emit) async
  {
    if((state as ChatSettingsInitial).email.isEmpty || (state as ChatSettingsInitial).emailError.isNotEmpty)
    {
      emit((state as ChatSettingsInitial).copyThis(
        emailError: LocaleKeys.paymentScreen_emailForReceiptError_emailInvalid.tr(),
      ));
      return;
    }

    UserProfileData profile = (state as ChatSettingsInitial).userData!;
    profile.emailNotification = EmailNotification(
      isEnabled: !(state as ChatSettingsInitial).notifyEnable,
      email: (state as ChatSettingsInitial).email,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await NetworkService().UpdateuserInfo(
        prefs.getString("token").toString(),
        profile.returnUserData(),
      );
    } catch (e) {
      emit((state as ChatSettingsInitial).copyThis(
        screenState: ScreenState.error,
      ));
      return;
    }

    emit((state as ChatSettingsInitial).copyThis(
      userData: profile,
      email: profile.emailNotification.email,
      notifyEnable: profile.emailNotification.isEnabled,
      screenState: ScreenState.ready,
    ));
  }
}

enum ScreenState{
  preload,
  ready,
  processed,
  error,
}