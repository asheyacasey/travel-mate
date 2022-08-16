import 'package:equatable/equatable.dart';
import 'package:travel_mate/models/category_filter_model.dart';
import 'package:travel_mate/models/category_model.dart';

class Filter extends Equatable {
  final List<CategoryFilter> categoryFilters;

  const Filter({
    this.categoryFilters = const <CategoryFilter>[],
  });

  Filter copyWith({
    List<CategoryFilter>? categoryFilters
  }){
    return Filter(
      categoryFilters: categoryFilters ?? this.categoryFilters
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [categoryFilters];

}