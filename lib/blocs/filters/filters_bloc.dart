import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:travel_mate/models/category_model.dart';

import '../../models/category_filter_model.dart';
import '../../models/filter_model.dart';

part 'filters_event.dart';
part 'filters_state.dart';

class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {
  FiltersBloc() : super(FiltersLoading()) {
    // on<FiltersEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    @override
    Stream<FiltersState> mapEventToState(
    FiltersEvent event,
    ) async* {
      if (event is FilterLoaded) {
        yield* _mapFilterLoadToState();
      }
      if (event is CategoryFilterUpdated){
        yield* _mapCategoryFilterUpdatedToState(event, state);
      }
    }
  }

  Stream<FiltersState> _mapFilterLoadToState() async* {

    yield FiltersLoaded(
        filter: Filter(
         categoryFilters: CategoryFilter.filters,
        )
    );
  }

  Stream<FiltersState> _mapCategoryFilterUpdatedToState(
      CategoryFilterUpdated event,
      FiltersState state)
  async* {
    if (state is FiltersLoaded) {
      final List<CategoryFilter> updatedCategoryFilters =
          state.filter.categoryFilters.map((categoryFilter) {
          return categoryFilter.id == event.categoryFilter.id
              ? event.categoryFilter
              : categoryFilter;
          }).toList();

      yield FiltersLoaded(
        filter: Filter(
          categoryFilters: updatedCategoryFilters
        )
      );
    }
  }

}
