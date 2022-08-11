import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:travel_mate/models/models.dart';

import '../../repositories/database/database_repository.dart';
import '../auth/auth_bloc.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;

  SwipeBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
  })  : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        super(SwipeLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateHome>(_onUpdateHome);
    on<SwipeLeft>(_onSwipeLeft);
    on<SwipeRight>(_onSwipeRight);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.status == AuthStatus.authenticated) {
        add(LoadUsers(userID: state.user!.uid));
      }
    });
  }

  void _onLoadUsers(LoadUsers event, Emitter<SwipeState> emit) {
    _databaseRepository.getUsers(event.userID, 'Male').listen((users) {
      debugPrint('$users');
      add(UpdateHome(users: users));
    });
  }

  void _onUpdateHome(UpdateHome event, Emitter<SwipeState> emit) {
    if (event.users != null) {
      emit(SwipeLoaded(users: event.users!));
    } else {
      emit(SwipeError());
    }
  }

  void _onSwipeLeft(SwipeLeft event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;

      List<User> users = List.from(state.users)..remove(event.user);

      if (users.isNotEmpty) {
        emit(SwipeLoaded(users: users));
      } else {
        emit(SwipeError());
      }
    }
  }

  void _onSwipeRight(SwipeRight event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;

      List<User> users = List.from(state.users)..remove(event.user);

      if (users.isNotEmpty) {
        emit(SwipeLoaded(users: users));
      } else {
        emit(SwipeError());
      }
    }
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }

  // @override
  // Stream<SwipeState> mapEventToState(
  //   SwipeEvent event,
  // ) async* {
  //   if (event is LoadUsersEvent) {
  //     yield* _mapLoadUsersToState(event);
  //   }
  //   if (event is SwipeLeftEvent) {
  //     yield* _mapSwipeLeftToState(event, state);
  //   }
  //   if (event is SwipeRightEvent) {
  //     yield* _mapSwipeRightToState(event, state);
  //   }
  // }
  //
  // Stream<SwipeState> _mapLoadUsersToState(
  //   LoadUsersEvent event,
  // ) async* {
  //   yield SwipeLoaded(users: event.users);
  // }
  //
  // Stream<SwipeState> _mapSwipeLeftToState(
  //   SwipeLeftEvent event,
  //   SwipeState state,
  // ) async* {
  //   if (state is SwipeLoaded) {
  //     try {
  //       yield SwipeLoaded(users: List.from(state.users)..remove(event.user));
  //     } catch (_) {}
  //   }
  // }
  //
  // Stream<SwipeState> _mapSwipeRightToState(
  //   SwipeRightEvent event,
  //   SwipeState state,
  // ) async* {
  //   if (state is SwipeLoaded) {
  //     try {
  //       yield SwipeLoaded(users: List.from(state.users)..remove(event.user));
  //     } catch (_) {}
  //   }
  // }
}
