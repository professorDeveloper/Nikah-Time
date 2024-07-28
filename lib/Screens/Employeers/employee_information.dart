import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/widgets/image_viewer.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/widgets/custom_appbar.dart';

import 'dart:async';

import 'package:equatable/equatable.dart';


import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:untitled/generated/locale_keys.g.dart';

part "view/employee_information_page.dart";

part "bloc/employer_bloc.dart";
part "bloc/employer_event.dart";
part "bloc/employer_state.dart";

part 'employee_information.g.dart';

enum EmployerScreenState
{
  preload,
  inProcess,
  canSave,
  error,
  ready,
  extendedReady
}

@JsonSerializable()
class PeopleList
{
  final String position;
  final List<PeopleCard> items;

  PeopleList({required this.position, required this.items});

  factory PeopleList.fromJson(Map<String, dynamic> json) => _$PeopleListFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleListToJson(this);

}

@JsonSerializable()
class PeopleCard
{
  final int       id;
  final String    name;
  final String    workPosition;
  final String?   education;
  final String?   description;
  final String    image;
  final String?   phone;
  final int?      price;
  final String?    url;

  @JsonKey(ignore: true)
  late EmployerType type;

  PeopleCard({
    required this.id,
    required this.name,
    required this.workPosition,
    this.education,
    this.description,
    required this.image,
    this.phone,
    this.price,
    required this.url,
  });

  factory PeopleCard.fromJson(Map<String, dynamic> json) => _$PeopleCardFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleCardToJson(this);

}

enum EmployerType
{
  directors,
  associateDirectors,
  curators,
  psychologists,
  hazrats,
}

Map<String, String> employerHeader = {
  "directors" : LocaleKeys.profileScreen_settings_directors,
  "associateDirectors" : LocaleKeys.profileScreen_settings_associateDirectors,
  "curators" : LocaleKeys.profileScreen_settings_curators,
  "psychologists" : LocaleKeys.profileScreen_settings_psychologists,
  "hazrats" : LocaleKeys.profileScreen_settings_hazrats,
};