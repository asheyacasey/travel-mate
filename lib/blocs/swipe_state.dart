part of 'swipe_bloc.dart';

abstract class SwipeState extends Equatable {
  const SwipeState();
}

class SwipeLoading extends SwipeState {
  @override
  List<Object> get props => [];
}


class SwipeLoaded extends SwipeState {
    final List<User> users;

    const SwipeLoaded({
    required this.users,
    });

    @override
    List<Object> get props => [users];

}


class SwipeError extends SwipeState {
  @override
  List<Object> get props => [];
}