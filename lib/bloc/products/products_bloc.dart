// import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:qrcode_bloc/models/products.dart';
import 'package:pdf/widgets.dart' as pd;
import 'package:open_file/open_file.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Products>> streamProducts() async* {
    yield* firestore
        .collection("product")
        .withConverter<Products>(
            fromFirestore: (snapshot, _) => Products.fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson())
        .snapshots();
  }

  ProductsBloc() : super(ProductsStateInitial()) {
    on<ProductsEventAddProduct>((event, emit) async {
      try {
        emit(ProductsStateLoadingAdd());
        //menambahkan produk ke firebase
        var hasil = await firestore
            .collection("product")
            .add({"name": event.name, "code": event.code, "qty": event.qty});
        await firestore.collection("product").doc(hasil.id).update({
          "productid": hasil.id,
        });
        emit(ProductsStateCompleteAdd());
      } on FirebaseException catch (e) {
        emit(ProductsStateError(
            e.message ?? "an error occurred, product cannot be added"));
      } catch (e) {
        emit(ProductsStateError("an error occurred, product cannot be added"));
      }
    });
    on<ProductsEventEditProduct>((event, emit) async {
      try {
        emit(ProductsStateLoadingEdit());
        //menambahkan produk ke firebase
        await firestore
            .collection("product")
            .doc(event.productid)
            .update({"name": event.name, "qty": event.qty});
        emit(ProductsStateCompleteEdit());
      } on FirebaseException catch (e) {
        emit(ProductsStateError(
            e.message ?? "an error occurred, product cannot be edit"));
      } catch (e) {
        emit(ProductsStateError("an error occurred, product cannot be edit"));
      }
    });
    on<ProductsEventDeleteProduct>((event, emit) async {
      try {
        emit(ProductsStateLoadingDelete());
        //menghapus produk ke firebase
        await firestore.collection("product").doc(event.id).delete();
        emit(ProductsStateCompleteDelete());
      } on FirebaseException catch (e) {
        emit(ProductsStateError(
            e.message ?? "an error occurred, product cannot be delete"));
      } catch (e) {
        emit(ProductsStateError("an error occurred, product cannot be delete"));
      }
    });
    on<ProductsEventExportToPdfProduct>((event, emit) async {
      try {
        emit(ProductsStateLoadingExportPdf());
        // 1. get all data from firebase
        var querySnap = await firestore
            .collection("product")
            .withConverter<Products>(
                fromFirestore: (snapshot, _) =>
                    Products.fromJson(snapshot.data()!),
                toFirestore: (model, _) => model.toJson())
            .get();

        List<Products> allProduct = [];
        for (var element in querySnap.docs) {
          Products prod = element.data();
          allProduct.add(prod);
        }
        // allProduct already filled
        // 2. create pdf -> save data in local storage-> need path
        final pdf = pd.Document();
        var data = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
        var myFont = Font.ttf(data);
        var myStyle = pd.TextStyle(font: myFont);
        pdf.addPage(pd.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            List<pd.Widget> widgets = [];

            // Add products to PDF
            for (var product in allProduct) {
              widgets.add(
                  pd.Text("Product ID: ${product.productid}", style: myStyle));
              widgets.add(pd.Text("Name: ${product.name}", style: myStyle));
              widgets.add(pd.Text("Code: ${product.code}", style: myStyle));
              widgets.add(pd.Text("Quantity: ${product.qty}", style: myStyle));
              widgets.add(pd.SizedBox(height: 10));
            }
            return widgets;
          },
        ));
        //Open Pdf
        Uint8List bytes = await pdf.save();
        final dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/myproducts.pdf");
        // Input bytes into a PDF file
        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);

        emit(ProductsStateCompleteExport());
      } on FirebaseException catch (e) {
        emit(ProductsStateError(
            e.message ?? "an error occurred, product cannot be export pdf"));
      } catch (e) {
        emit(ProductsStateError(
            "an error occurred, product cannot be export pdf"));
      }
    });
  }
}
