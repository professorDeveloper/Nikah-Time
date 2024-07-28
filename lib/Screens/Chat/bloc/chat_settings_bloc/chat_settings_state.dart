part of 'chat_settings_bloc.dart';

@immutable
abstract class ChatSettingsState {}

class ChatSettingsInitial extends ChatSettingsState {

  final UserProfileData? userData;
  final ScreenState screenState;

  final bool notifyEnable;
  final String email;
  final String emailError;

  ChatSettingsInitial({
    this.userData,
    this.email = '',
    this.emailError = '',
    this.notifyEnable = false,
    this.screenState = ScreenState.preload,
  });

  ChatSettingsInitial copyThis({
    UserProfileData? userData,
    String? email,
    String? emailError,
    bool? notifyEnable,
    ScreenState? screenState,
  })
  {
    return ChatSettingsInitial(
      userData: userData ?? this.userData,
      email: email ?? this.email,
      emailError: emailError ?? this.emailError,
      notifyEnable: notifyEnable ?? this.notifyEnable,
      screenState: screenState ?? this.screenState,
    );
  }

}
