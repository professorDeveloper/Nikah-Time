import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/components/items/strings_list.dart';
import 'package:untitled/components/models/email_notification.dart';

part 'user_profile_data.g.dart';

@JsonSerializable()
class UserFilter {
  bool? isOnline;
  double minAge = 18;
  double maxAge = 99;
  String? gender = "";
  String? country = "";
  String? city = "";
  String? education = "";
  String? typeReligion = "";
  String? placeOfStudy = "";
  String? placeOfWork = "";
  String? workPosition = "";
  String? maritalStatus = "";
  bool? haveChildren;
  bool? haveBadHabbits;
  List<String>? badHabits;
  List<String>? interests;
  String? nationality = "";
  String? observeIslamCanons = "";
  String? religiousAffiliation = "";
  int? religionId;
  UserFilter();

  bool isEmpty() {
    if (country == "" &&
        city == "" &&
        education == "" &&
        placeOfStudy == "" &&
        placeOfWork == "" &&
        typeReligion == "" &&
        workPosition == "" &&
        maritalStatus == "" &&
        nationality == "" &&
        observeIslamCanons == "" &&
        haveChildren == null &&
        badHabits == null &&
        interests == null &&
        religionId == null) return true;

    return false;
  }

  factory UserFilter.fromJson(Map<String, dynamic> json) =>
      _$UserFilterFromJson(json);

  Map<String, dynamic> toJson() => _$UserFilterToJson(this);
}

@JsonSerializable()
class UserProfileImage {
  final String? main;
  final String? preview;

  UserProfileImage({required this.main, required this.preview});

  factory UserProfileImage.fromJson(Map<String, dynamic> json) =>
      _$UserProfileImageFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileImageToJson(this);
}

@JsonSerializable()
class UserProfileData {
  bool? isProfileParametersMatched;
  bool? isOnline;
  int? id;
  String? firstName;
  String? lastName;
  List<String>? photos;
  List<UserProfileImage>? images;
  String? gender;
  String? birthDate;
  int? age;
  String? country;
  String? city;
  String? typeReligion;
  String? contactPhoneNumber;
  String? education;
  String? placeOfStudy;
  String? placeOfWork;
  String? workPosition;
  String? maritalStatus;
  bool? haveChildren;
  List<String>? badHabits;
  bool isBadHabitsFilled;
  List<String>? interests;
  String? about;
  String? nationality;
  String? observeIslamCanons;

  String? firebaseToken;
  String? accessToken;
  String? refreshToken;

  Tariff? userTariff;
  int? religionId;
  UserFilter filter = UserFilter();

  bool isVisible = false;
  bool inFavourite = false;
  bool isBlocked = false;

  EmailNotification emailNotification;

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    var userProfileData = UserProfileData();
    userProfileData.jsonToData(json);
    return userProfileData;
  }

  Map<String, dynamic> toJson() {
    return dataToJSON();
  }

  void jsonToData(Map<dynamic, dynamic> json) {
    photos = List<String>.from(json["photos"]);
    gender = json["gender"];
    birthDate = json["birthDate"];
    age = json["age"];
    country = json["country"];
    city = json["city"];
    contactPhoneNumber = json["contactPhoneNumber"];
    education = json["education"];
    typeReligion = json["type"];
    placeOfStudy = json["placeOfStudy"];
    placeOfWork = json["placeOfWork"];
    workPosition = json["workPosition"];
    maritalStatus = json["maritalStatus"];
    haveChildren = json["haveChildren"];
    badHabits = List<String>.from(json["badHabits"]);
    isBadHabitsFilled = json["isBadHabitsFilled"];
    interests = List<String>.from(json["interests"]);
    about = json["about"];
    isOnline = json["isOnline"];
    isProfileParametersMatched = json["isProfileParametersMatched"];
    id = json['id'];
    firstName = json['firstName'];
    lastName = json["lastName"];
    nationality = json["nationality"];
    observeIslamCanons = json["observeCanons"];
    userTariff = (json["tariff"] == null)
        ? null
        : Tariff(
            title: (json["tariff"] as Map<dynamic, dynamic>)["title"],
            expiredAt: (json["tariff"] as Map<dynamic, dynamic>)["expiredAt"]);

    List<dynamic> list = json["images"];
    if (list.isNotEmpty) {
      images = [];
      for (final item in list) {
        images!.add(
            UserProfileImage(main: item["main"], preview: item["preview"]));
      }
    }

    inFavourite = json["inFavourite"] ?? false;
    isBlocked = json["isBlocked"];
    emailNotification = EmailNotification.fromJson(
        json["emailNotification"] ?? <String, dynamic>{});
    religionId = json["religionId"];
  }

  Map<String, dynamic> dataToJSON() {
    if (interests != null && interests!.isNotEmpty) {
      for (int i = 0; i < interests!.length; i++) {
        try {
          String str = interests![i].toLowerCase();
          interests![i] = standartInterestList[str]!;
        } catch (err) {}
      }
    }

    List<Map<String, dynamic>> jsonImages = [];
    if (images != null) {
      for (final image in images!) {
        jsonImages.add(image.toJson());
      }
    }

    //Сервер не читает поле isBadHabitsFilled, при незаполненном поле
    //вредых привычек в поле badHabits должно быть null.
    List<String>? fixedBadHabits;
    if (isBadHabitsFilled == false) {
      fixedBadHabits = null;
    } else {
      fixedBadHabits = badHabits;
    }

    Map<String, dynamic> body = {
      'firstName': firstName,
      'lastName': lastName,
      'photos': [],
      'images': jsonImages,
      'gender': gender,
      'birthDate': birthDate,
      'country': country,
      'city': city,
      'contactPhoneNumber': contactPhoneNumber,
      'education': education,
      'type': typeReligion,
      "placeOfStudy": placeOfStudy,
      "placeOfWork": placeOfWork,
      "workPosition": workPosition,
      'maritalStatus': maritalStatus,
      "haveChildren": (haveChildren == true) ? "1" : "0",
      'badHabits': fixedBadHabits,
      // 'isBadHabitsFilled': isBadHabitsFilled,
      'interests': interests,
      'about': about,
      'isOnline': isOnline,
      "isProfileParametersMatched": isProfileParametersMatched,
      "nationality": nationality,
      "observeCanons": observeIslamCanons,
      "emailNotification": emailNotification.toJson(),
      "religionId": religionId,
    };
    return body;
  }

  void getDataFromJSON(Map<String, dynamic> data) {
    jsonToData(data["user"]);
    Map<dynamic, dynamic> token = data["tokenData"];
    accessToken = token["accessToken"];
    refreshToken = token["refreshToken"];
  }

  returnUserData() {
    debugPrint(jsonEncode(dataToJSON()));
    return (jsonEncode(dataToJSON()));
  }

  bool isValid() {
    return firstName != null &&
        lastName != null &&
        gender != null &&
        birthDate != null &&
        country != null &&
        city != null &&
        // typeReligion != null &&
        education != null &&
        placeOfWork != null &&
        // workPosition != null &&
        // nationality != null &&
        maritalStatus != null &&
        observeIslamCanons != null &&
        haveChildren != null;
  }

  bool hasMainPhoto() {
    bool hasMainPhoto = false;
    if (images != null) {
      if (images!.isEmpty == false) {
        if (images![0].main!.contains("http")) {
          hasMainPhoto = true;
        }
      }
    }
    return hasMainPhoto;
  }

  int getAdditionalPhotosLength() {
    int length = 0;
    if (images != null) {
      if (images!.isNotEmpty) {
        length = images!.length - 1;
      }
    }
    return length;
  }

  UserProfileData({
    this.isProfileParametersMatched,
    this.isOnline,
    this.id,
    this.firstName,
    this.lastName,
    this.photos,
    this.images,
    this.gender,
    this.birthDate,
    this.country,
    this.city,
    this.typeReligion,
    this.contactPhoneNumber,
    this.education,
    this.placeOfStudy,
    this.placeOfWork,
    this.workPosition,
    this.maritalStatus,
    this.haveChildren,
    this.badHabits,
    this.isBadHabitsFilled = false,
    this.interests,
    this.about,
    this.nationality,
    this.observeIslamCanons,
    this.firebaseToken,
    this.accessToken,
    this.refreshToken,
    this.userTariff,
    this.isBlocked = false,
    this.emailNotification = const EmailNotification(),
    this.religionId,
  });
}

@JsonSerializable()
class Tariff {
  final String? title;
  final String? expiredAt;

  Tariff({required this.title, required this.expiredAt});

  factory Tariff.fromJson(Map<String, dynamic> json) => _$TariffFromJson(json);

  Map<String, dynamic> toJson() => _$TariffToJson(this);
}
