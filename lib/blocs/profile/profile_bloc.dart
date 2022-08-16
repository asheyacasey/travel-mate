import 'dart:async';
//import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_mate/blocs/auth/auth_bloc.dart';
import 'package:travel_mate/repositories/database/database_repository.dart';

import '../../models/models.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;

  ProfileBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
  })  : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);

    _authSubscription = _authBloc.stream.listen((state) {
      if(state.user is AuthUserChanged){
        if (state.user != null) {
          add(LoadProfile(userId: state.authUser!.uid));
        }
      }
    });
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    _databaseRepository.getUser(event.userId).listen((user) {
      add(UpdateProfile(user: user));
    });
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) {
    print(event.user);
    emit(ProfileLoaded(user: event.user));
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }
}
