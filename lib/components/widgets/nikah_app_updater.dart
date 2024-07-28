import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:in_app_update/in_app_update.dart';
// import 'package:new_version/new_version.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class NikahAppUpdaterSharedPreferencesKey {
  static String get userAction => "AppUpdater.userAction";
  static String get timestamp => "AppUpdater.timestamp";
  static String get storeVersion => "AppUpdater.storeVersion";
}

class NikahAppUpdaterUserAction {
  static int get cancel => -1;
  static int get remind => 0;
  static int get update => 1;
}

class NikahAppUpdater {
  static const int _remindHoursCount = 1;

  late String _country;

  NikahAppUpdater({String country = "RU"}) {
    _country = country;
  }

  Future<bool> _userWantsToUpdate({required String storeVersion}) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    bool userWantsToUpdate = true;
    final lastUserAction =
      sharedPreferences.getInt(NikahAppUpdaterSharedPreferencesKey.userAction);
    if (lastUserAction != null) {
      if (lastUserAction == NikahAppUpdaterUserAction.remind) {
        final lastUserActionTimestamp = sharedPreferences.getInt(
            NikahAppUpdaterSharedPreferencesKey.timestamp
        ) ?? 0;
        final lastUserActionDateTime =
          DateTime.fromMillisecondsSinceEpoch(lastUserActionTimestamp);

        final hoursCount = DateTime.now().difference(lastUserActionDateTime).inHours;
        if (hoursCount < _remindHoursCount) {
          userWantsToUpdate = false;
        }
      } else if (lastUserAction == NikahAppUpdaterUserAction.cancel) {
        final lastUserActionVersion =
            sharedPreferences.getString(
                NikahAppUpdaterSharedPreferencesKey.storeVersion
            ) ?? "";
        if (storeVersion == lastUserActionVersion) {
          userWantsToUpdate = false;
        }
      }
    }

    return userWantsToUpdate;
  }

  Future<AppUpdateInfo?> getUpdateInfo() async {
    /*final packageInfo = await PackageInfo.fromPlatform();
    final iOsUpdater = NewVersion(
        iOSId: packageInfo.packageName,
        // по непонятной причине Apple для RU и ru может возвращать разные версии
        // без задания страны результат будет возращаться для версии для США
        // iOSAppStoreCountry: _country
    );

    if (Platform.isIOS) {
      final iOsUpdateInfo = await iOsUpdater.getVersionStatus();
      if (iOsUpdateInfo == null) {
        return null;
      }

      final userWantsToUpdate = await _userWantsToUpdate(
          storeVersion: iOsUpdateInfo.storeVersion
      );

      return AppUpdateInfo(
        storeLink: iOsUpdateInfo.appStoreLink,
        canUpdate: iOsUpdateInfo.canUpdate && userWantsToUpdate,
        currentVersionName: packageInfo.version,
        currentVersionCode: int.parse(packageInfo.buildNumber),
        storeVersionName: iOsUpdateInfo.storeVersion,
        storeVersionCode: null
      );
    } else if (Platform.isAndroid) {
      try{
        final androidUpdateInfo = await InAppUpdate.checkForUpdate();

        final userWantsToUpdate = await _userWantsToUpdate(
            storeVersion: androidUpdateInfo.availableVersionCode.toString());

        return AppUpdateInfo(
            storeLink:
                "https://play.google.com/store/apps/details?id=${packageInfo.packageName}&hl=$_country",
            canUpdate: androidUpdateInfo.updateAvailability ==
                    UpdateAvailability.updateAvailable &&
                androidUpdateInfo.immediateUpdateAllowed &&
                userWantsToUpdate,
            currentVersionName: packageInfo.version,
            currentVersionCode: int.parse(packageInfo.buildNumber),
            storeVersionName: null,
            storeVersionCode: androidUpdateInfo.availableVersionCode);
      }catch(err)
      {
        return null;
      }
    }
    */
    return null;

  }

  void showUpdateDialogIfNecessary({required BuildContext context}) {
    getUpdateInfo().then((info) {
      if (info == null) {
        return;
      }

      if (info.canUpdate) {
        showUpdateDialog(
            context: context,
            appUpdateInfo: info
        );
      }
    });
  }

  void _setSharedPreferences({
    required AppUpdateInfo appUpdateInfo,
    required int userAction
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setInt(
        NikahAppUpdaterSharedPreferencesKey.userAction,
        userAction
    );
    sharedPreferences.setInt(
        NikahAppUpdaterSharedPreferencesKey.timestamp,
        DateTime.now().millisecondsSinceEpoch
    );
    sharedPreferences.setString(
        NikahAppUpdaterSharedPreferencesKey.storeVersion,
        Platform.isIOS ? appUpdateInfo.storeVersionName! : appUpdateInfo.storeVersionCode.toString()
    );
  }

  void showUpdateDialog({
    required BuildContext context,
    required AppUpdateInfo appUpdateInfo
  }) async {
/*    final packageInfo = await PackageInfo.fromPlatform();
    final iOsUpdater = NewVersion(
        iOSId: packageInfo.packageName,
        iOSAppStoreCountry: _country
    );

    Widget remindButton = TextButton(
      child: Text(LocaleKeys.appUpdater_remindAction.tr()),
      onPressed:  () {
        _setSharedPreferences(
            appUpdateInfo: appUpdateInfo,
            userAction: NikahAppUpdaterUserAction.remind
        );
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget cancelButton = TextButton(
      child: Text(LocaleKeys.appUpdater_cancelAction.tr()),
      onPressed:  () {
        _setSharedPreferences(
            appUpdateInfo: appUpdateInfo,
            userAction: NikahAppUpdaterUserAction.cancel
        );
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget updateButton = TextButton(
      child: Text(LocaleKeys.appUpdater_updateAction.tr()),
      onPressed:  () {
        _setSharedPreferences(
            appUpdateInfo: appUpdateInfo,
            userAction: NikahAppUpdaterUserAction.update
        );
        if (Platform.isIOS) {
          iOsUpdater.launchAppStore(appUpdateInfo.storeLink);
        } else if (Platform.isAndroid) {
          InAppUpdate.performImmediateUpdate();
        }
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(LocaleKeys.appUpdater_title.tr()),
      content: Text(LocaleKeys.appUpdater_description.tr()),
      actions: [
        cancelButton,
        remindButton,
        updateButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );*/
  }
}

class AppUpdateInfo {
  final String storeLink;
  final bool canUpdate;
  final String currentVersionName;
  final int currentVersionCode;

  //null на Android
  final String? storeVersionName;

  //null на iOS
  final int? storeVersionCode;

  AppUpdateInfo({
    required this.storeLink,
    required this.canUpdate,
    required this.currentVersionCode,
    required this.currentVersionName,
    required this.storeVersionCode,
    required this.storeVersionName
  });
}