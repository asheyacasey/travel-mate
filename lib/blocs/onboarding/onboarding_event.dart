part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class StartOnboarding extends OnboardingEvent {
  final User user;

  StartOnboarding({
    this.user = const User(
      id: '',
      name: '',
      age: 0,
      gender: '',
      imageUrls: [],
      interests: [],
      bio: '',
      jobTitle: '',
    ),
  });

  @override
  List<Object?> get props => [user];
}

// class UpdateUserLocation extends OnboardingEvent {
//   //final Location? location;
//   final GoogleMapController? controller;
//   final bool isUpdateComplete;
//
//   UpdateUserLocation({
//     //this.location,
//     this.controller,
//     this.isUpdateComplete = false,
//   });
//
//   @override
//   List<Object?> get props => [
//         //location,
//         controller,
//         isUpdateComplete,
//       ];
// }

class UpdateUser extends OnboardingEvent {
  final User user;

  UpdateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserInterest extends OnboardingEvent {
  final User user;
  final String? interest;

  UpdateUserInterest({required this.user, this.interest});

  @override
  List<Object?> get props => [user, interest];
}

class UpdateUserImages extends OnboardingEvent {
  final User? user;
  final XFile image;

  UpdateUserImages({this.user, required this.image});

  @override
  List<Object?> get props => [user, image];
}
