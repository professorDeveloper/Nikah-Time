part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfileDataEvent extends ProfileEvent
{
  const LoadProfileDataEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileDataEvent extends ProfileEvent
{
  final UserProfileData userProfileData;

  const UpdateProfileDataEvent({required this.userProfileData});

  @override
  List<Object?> get props => [];
}

class UploadProfileDataEvent extends ProfileEvent
{
  const UploadProfileDataEvent();

  @override
  List<Object?> get props => [];
}


class ClearProfileInfo extends ProfileEvent
{
  const ClearProfileInfo();

  @override
  List<Object?> get props => [];
}