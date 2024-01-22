part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

class ProductsEventAddProduct extends ProductsEvent {
  ProductsEventAddProduct(
      {required this.code, required this.name, required this.qty});
  final String code;
  final String name;
  final int qty;
}

class ProductsEventEditProduct extends ProductsEvent {
  ProductsEventEditProduct(
      {required this.productid, required this.name, required this.qty});
  final String productid;
  final String name;
  final int qty;
}

class ProductsEventDeleteProduct extends ProductsEvent {
  ProductsEventDeleteProduct(this.id);
  final String id;
}

class ProductsEventExportToPdfProduct extends ProductsEvent {}
