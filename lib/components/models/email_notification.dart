

import 'package:json_annotation/json_annotation.dart';

part 'email_notification.g.dart';

@JsonSerializable()
class EmailNotification{
  final bool isEnabled;
  final String email;

  const EmailNotification({
    this.isEnabled = false,
    this.email = '',
  });

  factory EmailNotification.fromJson(Map<String, dynamic> json) => _$EmailNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$EmailNotificationToJson(this);
}