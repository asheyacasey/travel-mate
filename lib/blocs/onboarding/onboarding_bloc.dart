// import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_mate/repositories/database/database_repository.dart';
import 'package:travel_mate/repositories/repositories.dart';

import '../../models/models.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
  final LocationRepository _locationRepository;

  OnboardingBloc({
    required DatabaseRepository databaseRepository,
    required StorageRepository storageRepostitory,
    required LocationRepository locationRepository,
  })  : _databaseRepository = databaseRepository,
        _storageRepository = storageRepostitory,
        _locationRepository = locationRepository,
        super(OnboardingLoading()) {
    on<StartOnboarding>(_onStartOnboarding);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserImages>(_onUpdateUserImages);
    on<UpdateUserInterest>(_onUpdateUserInterest);
    on<UpdateUserLocation>(_onUpdateUserLocation);
  }

  void _onStartOnboarding(
    StartOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    await _databaseRepository.createUser(event.user);
    emit(OnboardingLoaded(user: event.user));
  }

  void _onUpdateUser(
    UpdateUser event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      _databaseRepository.updateUser(event.user);
      emit(OnboardingLoaded(user: event.user));
    }
  }

  void _onUpdateUserInterest(
    UpdateUserInterest event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      _databaseRepository.UpdateUserInterest(event.user, event.interest);
      emit(OnboardingLoaded(user: event.user));
    }
  }

  void _onUpdateUserImages(
      UpdateUserImages event,
      Emitter<OnboardingState> emit,
      ) async {
    if (state is OnboardingLoaded) {
      User user = (state as OnboardingLoaded).user;

      final imageUrl = await _storageRepository.uploadImage(user, event.image);
      print('Uploaded image URL: $imageUrl');

      // Assuming that the 'updateUserPictures' method exists in your '_databaseRepository'
      // and that it correctly updates the Firestore database with the new image URL
      await _databaseRepository.updateUserPictures(user, imageUrl);

      _databaseRepository.getUser(user.id!).listen((user) {
        print('Updated user image URLs: ${user.imageUrls}');
        add(UpdateUser(user: user));
      });
    }
  }
  void _onUpdateUserLocation(
    UpdateUserLocation event,
    Emitter<OnboardingState> emit,
  ) async {
    final state = this.state as OnboardingLoaded;

    if (event.isUpdateComplete && event.location != null) {
      print('Getting the location with the Places API');

      final Location location =
          await _locationRepository.getLocation(event.location!.name);

      state.controller!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            location.lat,
            location.lon,
          ),
        ),
      );

      _databaseRepository.getUser(state.user.id!).listen((user) {
        add(UpdateUser(user: state.user.copyWith(location: location)));
      });
    } else {
      emit(OnboardingLoaded(
        user: state.user.copyWith(location: event.location),
        controller: event.controller ?? state.controller,
      ));
    }
  }
}
