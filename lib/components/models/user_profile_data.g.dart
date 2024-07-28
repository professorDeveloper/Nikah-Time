// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFilter _$UserFilterFromJson(Map<String, dynamic> json) => UserFilter()
  ..isOnline = json['isOnline'] as bool?
  ..minAge = (json['minAge'] as num).toDouble()
  ..maxAge = (json['maxAge'] as num).toDouble()
  ..gender = json['gender'] as String?
  ..country = json['country'] as String?
  ..city = json['city'] as String?
  ..education = json['education'] as String?
  ..typeReligion = json['typeReligion'] as String?
  ..placeOfStudy = json['placeOfStudy'] as String?
  ..placeOfWork = json['placeOfWork'] as String?
  ..workPosition = json['workPosition'] as String?
  ..maritalStatus = json['maritalStatus'] as String?
  ..haveChildren = json['haveChildren'] as bool?
  ..haveBadHabbits = json['haveBadHabbits'] as bool?
  ..badHabits =
      (json['badHabits'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..interests =
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..nationality = json['nationality'] as String?
  ..observeIslamCanons = json['observeIslamCanons'] as String?
  ..religionId = json['religionId'] as int?;

Map<String, dynamic> _$UserFilterToJson(UserFilter instance) =>
    <String, dynamic>{
      'isOnline': instance.isOnline,
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'gender': instance.gender,
      'country': instance.country,
      'city': instance.city,
      'education': instance.education,
      'typeReligion': instance.typeReligion,
      'placeOfStudy': instance.placeOfStudy,
      'placeOfWork': instance.placeOfWork,
      'workPosition': instance.workPosition,
      'maritalStatus': instance.maritalStatus,
      'haveChildren': instance.haveChildren,
      'haveBadHabbits': instance.haveBadHabbits,
      'badHabits': instance.badHabits,
      'interests': instance.interests,
      'nationality': instance.nationality,
      'observeIslamCanons': instance.observeIslamCanons,
      'religionId': instance.religionId,
    };

UserProfileImage _$UserProfileImageFromJson(Map<String, dynamic> json) =>
    UserProfileImage(
      main: json['main'] as String?,
      preview: json['preview'] as String?,
    );

Map<String, dynamic> _$UserProfileImageToJson(UserProfileImage instance) =>
    <String, dynamic>{
      'main': instance.main,
      'preview': instance.preview,
    };

UserProfileData _$UserProfileDataFromJson(Map<String, dynamic> json) =>
    UserProfileData(
      isProfileParametersMatched: json['isProfileParametersMatched'] as bool?,
      isOnline: json['isOnline'] as bool?,
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => UserProfileImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      typeReligion: json['typeReligion'] as String?,
      contactPhoneNumber: json['contactPhoneNumber'] as String?,
      education: json['education'] as String?,
      placeOfStudy: json['placeOfStudy'] as String?,
      placeOfWork: json['placeOfWork'] as String?,
      workPosition: json['workPosition'] as String?,
      maritalStatus: json['maritalStatus'] as String?,
      haveChildren: json['haveChildren'] as bool?,
      badHabits: (json['badHabits'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isBadHabitsFilled: json['isBadHabitsFilled'] as bool? ?? false,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      about: json['about'] as String?,
      nationality: json['nationality'] as String?,
      observeIslamCanons: json['observeIslamCanons'] as String?,
      firebaseToken: json['firebaseToken'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      userTariff: json['userTariff'] == null
          ? null
          : Tariff.fromJson(json['userTariff'] as Map<String, dynamic>),
      isBlocked: json['isBlocked'] as bool? ?? false,
      emailNotification: json['emailNotification'] == null
          ? const EmailNotification()
          : EmailNotification.fromJson(
              json['emailNotification'] as Map<String, dynamic>),
      religionId: json['religionId'] as int?,
    )
      ..age = json['age'] as int?
      ..filter = UserFilter.fromJson(json['filter'] as Map<String, dynamic>)
      ..isVisible = json['isVisible'] as bool
      ..inFavourite = json['inFavourite'] as bool;

Map<String, dynamic> _$UserProfileDataToJson(UserProfileData instance) =>
    <String, dynamic>{
      'isProfileParametersMatched': instance.isProfileParametersMatched,
      'isOnline': instance.isOnline,
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'photos': instance.photos,
      'images': instance.images,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
      'age': instance.age,
      'country': instance.country,
      'city': instance.city,
      'typeReligion': instance.typeReligion,
      'contactPhoneNumber': instance.contactPhoneNumber,
      'education': instance.education,
      'placeOfStudy': instance.placeOfStudy,
      'placeOfWork': instance.placeOfWork,
      'workPosition': instance.workPosition,
      'maritalStatus': instance.maritalStatus,
      'haveChildren': instance.haveChildren,
      'badHabits': instance.badHabits,
      'isBadHabitsFilled': instance.isBadHabitsFilled,
      'interests': instance.interests,
      'about': instance.about,
      'nationality': instance.nationality,
      'observeIslamCanons': instance.observeIslamCanons,
      'firebaseToken': instance.firebaseToken,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'userTariff': instance.userTariff,
      'religionId': instance.religionId,
      'filter': instance.filter,
      'isVisible': instance.isVisible,
      'inFavourite': instance.inFavourite,
      'isBlocked': instance.isBlocked,
      'emailNotification': instance.emailNotification,
    };

Tariff _$TariffFromJson(Map<String, dynamic> json) => Tariff(
      title: json['title'] as String?,
      expiredAt: json['expiredAt'] as String?,
    );

Map<String, dynamic> _$TariffToJson(Tariff instance) => <String, dynamic>{
      'title': instance.title,
      'expiredAt': instance.expiredAt,
    };
