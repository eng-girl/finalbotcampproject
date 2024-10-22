import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../core/constants/api_constants.dart';
import '../state/category_state.dart';


class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final Dio dio = Dio();

  // Function to fetch categories
  Future<void> fetchCategories() async {
    try {
      emit(CategoryLoading()); // Set loading state
      final response = await dio.get(ApiConstants.categories);
      if (response.statusCode == 200) {
        final categories = List<String>.from(response.data['data']['categories']);
        emit(CategoryLoaded(categories)); // Set loaded state with data
      } else {
        emit(CategoryError('Failed to load categories'));
      }
    } catch (e) {
      emit(CategoryError(e.toString())); // Set error state
    }
  }
}
