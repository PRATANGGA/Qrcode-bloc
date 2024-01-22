import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_bloc/bloc/bloc.dart';
import 'package:qrcode_bloc/models/products.dart';
import 'package:qrcode_bloc/routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductsBloc productBloc = context.read<ProductsBloc>();
    return Scaffold(
        appBar: AppBar(
          title: const Text("All Products"),
        ),
        body: StreamBuilder<QuerySnapshot<Products>>(
            stream: productBloc.streamProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("No data"),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Data not found"),
                );
              }
              List<Products> allProducts = [];
              for (var element in snapshot.data!.docs) {
                allProducts.add(element.data());
              }
              if (allProducts.isEmpty) {
                return const Center(
                  child: Text("No data"),
                );
              }
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {},
                child: ListView.builder(
                    itemCount: allProducts.length,
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (context, index) {
                      Products product = allProducts[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.only(bottom: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () {
                            context.goNamed(Routes.detailProduct,
                                pathParameters: {
                                  "productid": product.productid!,
                                },
                                // queryParameters: {
                                //   "product": product,
                                // }
                                extra: product);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            height: 100,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.code!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        product.name!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text("Jumlah : ${product.qty}"),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: QrImageView(
                                    data: product.code!,
                                    size: 200.0,
                                    version: QrVersions.auto,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }));
  }
}
