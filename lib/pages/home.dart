import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/bloc.dart';
import 'package:qrcode_bloc/routes/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: GoogleFonts.albertSans(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
          itemCount: 4,
          itemBuilder: (context, index) {
            late String title;
            late IconData icon;
            late VoidCallback onTap;

            switch (index) {
              case 0:
                title = "Add Product";
                icon = Icons.post_add_outlined;
                onTap = () {
                  context.goNamed(Routes.addProduct);
                };
                break;
              case 1:
                title = "Product";
                icon = Icons.list_alt_outlined;
                onTap = () {
                  context.goNamed(Routes.products);
                };
                break;
              case 2:
                title = "QR CODE";
                icon = Icons.qr_code;
                onTap = () {};
                break;
              case 3:
                title = "Catalog";
                icon = Icons.document_scanner;
                onTap = () {
                  context
                      .read<ProductsBloc>()
                      .add(ProductsEventExportToPdfProduct());
                };
                break;
              default:
            }
            return Material(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (index == 3)
                        ? BlocConsumer<ProductsBloc, ProductsState>(
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              if (state is ProductsStateLoadingExportPdf) {
                                return const CircularProgressIndicator();
                              }
                              return SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(
                                  icon,
                                  size: 50,
                                ),
                              );
                            },
                          )
                        : SizedBox(
                            height: 50,
                            width: 50,
                            child: Icon(
                              icon,
                              size: 50,
                            )),
                    SizedBox(
                      height: 50,
                    ),
                    Text(title),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthEventLogout());
        },
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStateLogout) {
              context.goNamed(Routes.login);
            }
          },
          builder: (context, state) {
            return Icon(Icons.logout);
          },
        ),
      ),
    );
  }
}
