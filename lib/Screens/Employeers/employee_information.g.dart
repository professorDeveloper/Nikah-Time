// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeopleList _$PeopleListFromJson(Map<String, dynamic> json) => PeopleList(
      position: json['position'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => PeopleCard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PeopleListToJson(PeopleList instance) =>
    <String, dynamic>{
      'position': instance.position,
      'items': instance.items,
    };

PeopleCard _$PeopleCardFromJson(Map<String, dynamic> json) => PeopleCard(
      id: json['id'] as int,
      name: json['name'] as String,
      workPosition: json['workPosition'] as String,
      education: json['education'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String,
      phone: json['phone'] as String?,
      price: json['price'] as int?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$PeopleCardToJson(PeopleCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workPosition': instance.workPosition,
      'education': instance.education,
      'description': instance.description,
      'image': instance.image,
      'phone': instance.phone,
      'price': instance.price,
      'url': instance.url,
    };
