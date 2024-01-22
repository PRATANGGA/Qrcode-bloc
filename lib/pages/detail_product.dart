import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_bloc/bloc/bloc.dart';
import 'package:qrcode_bloc/models/products.dart';
import 'package:qrcode_bloc/routes/router.dart';

class DetailProductPage extends StatelessWidget {
  DetailProductPage(this.id, this.products, {super.key});

  final String id;
  // final dynamic data;
  final Products products;
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    codeC.text = products.code!;
    nameC.text = products.name!;
    qtyC.text = products.qty!.toString();
    return Scaffold(
        appBar: AppBar(
          title: const Text("DETAIL PRODUCT PAGE"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: QrImageView(
                    data: products.code!,
                    size: 200.0,
                    version: QrVersions.auto,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
                autocorrect: false,
                controller: codeC,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: InputDecoration(
                    labelText: "Product Code",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)))),
            const SizedBox(
              height: 15.0,
            ),
            TextField(
                autocorrect: false,
                controller: nameC,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)))),
            const SizedBox(
              height: 15.0,
            ),
            TextField(
                autocorrect: false,
                controller: qtyC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)))),
            const SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ProductsBloc>().add(ProductsEventEditProduct(
                    productid: products.productid!,
                    name: nameC.text,
                    qty: int.tryParse(qtyC.text) ?? 0));
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: BlocConsumer<ProductsBloc, ProductsState>(
                listener: (context, state) {
                  if (state is ProductsStateError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                  if (state is ProductsStateCompleteEdit) {
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return Text(state is ProductsStateLoadingEdit
                      ? "Loading ..."
                      : "Edit Product");
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  context
                      .read<ProductsBloc>()
                      .add(ProductsEventDeleteProduct(products.productid!));
                },
                child: BlocConsumer<ProductsBloc, ProductsState>(
                  listener: (context, state) {
                    if (state is ProductsStateError) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                    if (state is ProductsStateCompleteDelete) {
                      context.pop();
                    }
                  },
                  builder: (context, state) {
                    return Text(
                      state is ProductsStateLoadingDelete
                          ? "Loading...."
                          : "Delete Product",
                      style: const TextStyle(color: Colors.red),
                    );
                  },
                ))
          ],
        ));
  }
}
