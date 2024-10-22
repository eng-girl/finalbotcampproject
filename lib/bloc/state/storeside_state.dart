// storeside_state.dart
import '../../data/models/store_model.dart';

abstract class StoresideState {}

class StoreInitial extends StoresideState {}

class StoreLoading extends StoresideState {}

class StoreLoaded extends StoresideState {
  final Store store;

  StoreLoaded(this.store);
}

class StoreError extends StoresideState {
  final String message;

  StoreError(this.message);
}