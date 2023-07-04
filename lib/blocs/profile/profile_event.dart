part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile({required this.userId});

  List<Object?> get props => [userId];
}

class EditProfile extends ProfileEvent {
  final bool isEditingOn;

  const EditProfile({required this.isEditingOn});

  List<Object?> get props => [isEditingOn];
}

class SaveProfile extends ProfileEvent {
  final User user;

  SaveProfile({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserProfile extends ProfileEvent {
  final User user;

  UpdateUserProfile({required this.user});

  @override
  List<Object?> get props => [user];
}

//class UpdateUserLocation extends ProfileEvent {
//final Location? location;
//final GoogleMapController? controller;
//final bool isUpdateComplete;
//
//UpdateUserLocation({this.location, this.controller, this.isUpdateComplete = false});
//
//@override
//List<Object?> get props => [location, controller, isUpdateComplete];
//}