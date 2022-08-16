part of 'match_bloc.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object> get props => [];
}

class MatchLoaded extends MatchState {
  final List<Match> matches;

  const MatchLoaded({this.matches = const <Match>[]});

  List<Object> get props => [matches];
}

class MatchLoading extends MatchState {}

class MatchUnavailable extends MatchState {}
