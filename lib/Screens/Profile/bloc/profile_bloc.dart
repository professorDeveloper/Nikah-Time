import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';

part 'profile_event.dart';
part 'profile_state.dart';

enum ProfileScreenState
{
  preload,
  inProcess,
  canSave,
  error,
  ready
}


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileDataEvent>(_onLoadProfileEvent);
    on<UpdateProfileDataEvent>(_onUpdateProfileEvent);
    on<UploadProfileDataEvent>(_onUploadProfileEvent);
    on<ClearProfileInfo>(_onClearEvent);
  }

  void _onLoadProfileEvent(LoadProfileDataEvent event, Emitter emit) async
  {
    emit((state as ProfileInitial).copyThis(
      screenState: ProfileScreenState.inProcess,
    ));
    UserProfileData profile = UserProfileData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {


      var response = await NetworkService()
          .GetUserInfo(prefs.getString("token").toString());

      if (response.statusCode != 200) {
        return;
      }
      profile.jsonToData(jsonDecode(response.body)[0]);
      profile.accessToken = prefs.getString("token").toString();
    } catch (e) {
      return;
    }

    if(prefs.getInt("userId") == null)
    {
      prefs.setInt("userId", profile.id!);
    }

    emit((state as ProfileInitial).copyThis(
      userProfileData: profile,
      screenState: ProfileScreenState.ready,
    ));
  }

  void _onUpdateProfileEvent(UpdateProfileDataEvent event, Emitter emit) async
  {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getInt("userId") == null && event.userProfileData.id != null)
    {
      prefs.setInt("userId", event.userProfileData.id!);
    }
    if(prefs.getString("token") == null && event.userProfileData.accessToken != null)
    {
      prefs.setString("token", event.userProfileData.accessToken!);
    }
    if(prefs.getString("userGender") == null && event.userProfileData.gender != null)
    {
      prefs.setString("userGender", event.userProfileData.gender!);
    }

    emit((state as ProfileInitial).copyThis(
      userProfileData: event.userProfileData,
      screenState: ProfileScreenState.ready,
    ));
  }

  void _onUploadProfileEvent(UploadProfileDataEvent event, Emitter emit) async
  {
    emit((state as ProfileInitial).copyThis(
      screenState: ProfileScreenState.inProcess,
    ));
    UserProfileData profile = UserProfileData();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var response = await NetworkService().UpdateuserInfo(
        prefs.getString("token").toString(),
        (state as ProfileInitial).userProfileData!.returnUserData()
      );

      if (response.statusCode != 200) {
        return;
      }

    } catch (e) {
      return;
    }

    emit((state as ProfileInitial).copyThis(
      screenState: ProfileScreenState.ready,
    ));
  }

  void _onClearEvent(ClearProfileInfo event, Emitter emit) async
  {
    emit(ProfileInitial());
  }

}
