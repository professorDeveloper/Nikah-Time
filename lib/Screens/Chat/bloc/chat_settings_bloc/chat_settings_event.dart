part of 'chat_settings_bloc.dart';

@immutable
abstract class ChatSettingsEvent {}

class NotificationAction extends ChatSettingsEvent
{
  NotificationAction();
}

class InputAction extends ChatSettingsEvent
{
  final String data;

  InputAction({required this.data});
}

class LoadProfileInfo extends ChatSettingsEvent
{
  LoadProfileInfo();
}