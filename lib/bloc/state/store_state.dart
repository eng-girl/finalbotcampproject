import '../../data/models/store_model.dart';

sealed class StoreState {}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final Store store;

  StoreLoaded(this.store);
}

class StoreError extends StoreState {
  final String message;

  StoreError(this.message);
}

class StoresLoaded extends StoreState {
  final List<Store> stores;

  StoresLoaded(this.stores);
}