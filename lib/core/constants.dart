
import 'package:flutter/material.dart';

class AppStrings {
  static const String appName = 'Recipe Finder';
  static const String searchPlaceholder = 'Search recipes...';
  static const String favorites = 'Favorites';
  static const String ingredients = 'Ingredients';
  static const String instructions = 'Instructions';
  static const String overview = 'Overview';
  static const String noResults = 'No recipes found';
  static const String sortBy = 'Sort By';
  static const String filterByCategory = 'Category';
  static const String filterByArea = 'Cuisine';
  static const String clearFilters = 'Clear All';
}

class AppColors {
  static const Color primary = Color(0xFFFF5722);
  static const Color accent = Color(0xFFFFC107);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBg = Colors.white;
}

class ApiEndpoints {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const String searchByName = '/search.php?s=';
  static const String categories = '/categories.php';
  static const String areas = '/list.php?a=list';
  static const String lookup = '/lookup.php?i=';
}
