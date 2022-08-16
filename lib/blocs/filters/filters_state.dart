part of 'filters_bloc.dart';

@immutable
abstract class FiltersState {}

class FiltersLoading extends FiltersState {

}


class FiltersLoaded extends FiltersState {
  final Filter filter;

  FiltersLoaded({
    this.filter = const Filter(),
  });

  @override
  List<Object> get props => [filter];

}