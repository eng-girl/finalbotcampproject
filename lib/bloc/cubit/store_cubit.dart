import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../core/constants/api_constants.dart';
import '../../data/models/store_model.dart';
import '../state/store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  final Dio dio;

  StoreCubit(this.dio) : super(StoreInitial());

  Future<void> fetchStoreByUserId(String userId) async {
    try {
      emit(StoreLoading());
      final response = await dio.get('${ApiConstants.allStores}/$userId');

      print(response.data); // Print the response to check the structure

      if (response.statusCode == 200 && response.data['store'] != null) {
        final storeData = response.data['store'];
        final store = Store.fromJson(storeData);
        emit(StoreLoaded(store));
      } else {
        emit(StoreError('Failed to load store: ${response.statusCode}'));
      }
    } catch (e) {
      emit(StoreError('Failed to load store: $e'));
    }
  }

  Future<void> fetchAllStores() async {
    try {
      emit(StoreLoading());
      final response = await dio.get(ApiConstants.allStores);

      if (response.statusCode == 200) {
        print('Response data: ${response.data}'); // Log the response data

        List<Store> stores = (response.data as List)
            .map((storeJson) => Store.fromJson(storeJson['store']))
            .toList();

        emit(StoresLoaded(stores));
      } else {
        emit(StoreError('Failed to load stores: ${response.statusCode}'));
      }
    } catch (e) {
      emit(StoreError('Failed to load stores: $e'));
    }
  }


}
