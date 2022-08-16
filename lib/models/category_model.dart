import 'package:equatable/equatable.dart';
import 'package:travel_mate/models/category_filter_model.dart';

class Category extends Equatable {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  static List<Category> categories = [
    Category(id: 1, name: 'Hiking'),
    Category(id: 2, name: 'Swimming'),
    Category(id: 3, name: 'Coffee Hoping'),
  ];

  static List<CategoryFilter> filters = Category.categories
      .map((category) => CategoryFilter(
            id: category.id,
            category: category,
            value: false,
          ))
      .toList();
}
