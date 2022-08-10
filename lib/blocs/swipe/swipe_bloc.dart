import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:travel_mate/models/models.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  SwipeBloc() : super(SwipeLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<SwipeLeft>(_onSwipeLeft);
    on<SwipeRight>(_onSwipeRight);
  }

  void _onLoadUsers(
    LoadUsers event,
    Emitter<SwipeState> emit,
  ) {
    emit(SwipeLoaded(users: event.users));
  }

  void _onSwipeLeft(
    SwipeLeft event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;
      try {
        emit(
          SwipeLoaded(
            users: List.from(state.users)..remove(event.user),
          ),
        );
      } catch (_) {}
    }
  }

  void _onSwipeRight(
    SwipeRight event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;
      try {
        emit(
          SwipeLoaded(
            users: List.from(state.users)..remove(event.user),
          ),
        );
      } catch (_) {}
    }
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
