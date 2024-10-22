// storeside_cubit.dart
import 'package:bloc/bloc.dart';

import '../../data/repo/storeside_repository.dart';
import '../state/storeside_state.dart';


class StoresideCubit extends Cubit<StoresideState> {
  final StoresideRepository storeRepository;

  StoresideCubit(this.storeRepository) : super(StoreInitial());

  Future<void> fetchStore(String userId) async {
    emit(StoreLoading());
    try {
      final store = await storeRepository.getStoreByUserId(userId);
      if (store != null) {
        emit(StoreLoaded(store));
      } else {
        emit(StoreError('Failed to load store details.'));
      }
    } catch (e) {
      emit(StoreError('Error: $e'));
    }
  }
}