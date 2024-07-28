// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailNotification _$EmailNotificationFromJson(Map<String, dynamic> json) =>
    EmailNotification(
      isEnabled: json['isEnabled'] as bool? ?? false,
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$EmailNotificationToJson(EmailNotification instance) =>
    <String, dynamic>{
      'isEnabled': instance.isEnabled,
      'email': instance.email,
    };
