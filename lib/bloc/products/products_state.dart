part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsStateInitial extends ProductsState {}

final class ProductsStateLoadingEdit extends ProductsState {}

final class ProductsStateLoadingDelete extends ProductsState {}

final class ProductsStateLoadingAdd extends ProductsState {}

final class ProductsStateLoadingExportPdf extends ProductsState {}

final class ProductsStateCompleteAdd extends ProductsState {}

final class ProductsStateCompleteEdit extends ProductsState {}

final class ProductsStateCompleteDelete extends ProductsState {}

final class ProductsStateCompleteExport extends ProductsState {}

final class ProductsStateError extends ProductsState {
  ProductsStateError(this.message);
  final String message;
}
