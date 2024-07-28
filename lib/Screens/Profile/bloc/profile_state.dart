part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  final UserProfileData? userProfileData;
  final ProfileScreenState screenState;

  ProfileInitial({
    this.userProfileData,
    this.screenState = ProfileScreenState.preload
  });

  ProfileInitial copyThis({
    UserProfileData? userProfileData,
    ProfileScreenState? screenState
  }){
    return ProfileInitial(
      userProfileData: userProfileData ?? this.userProfileData,
      screenState: screenState ?? this.screenState
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    userProfileData,
    screenState
  ];


}
