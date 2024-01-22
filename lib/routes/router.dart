import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:qrcode_bloc/models/products.dart';
import 'package:qrcode_bloc/pages/add_product.dart';
import 'package:qrcode_bloc/pages/detail_product.dart';
import 'package:qrcode_bloc/pages/error.dart';
import 'package:qrcode_bloc/pages/home.dart';
import 'package:qrcode_bloc/pages/login.dart';
import 'package:qrcode_bloc/pages/products.dart';
export 'package:go_router/go_router.dart';
part 'route_name.dart';

final GoRouter _router = GoRouter(
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    print(auth.currentUser);
    //cek kondisi saat ini -> sedang terautentifikasi
    if (auth.currentUser == null) {
      return '/login';
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => const ErrorPage(),
  routes: <RouteBase>[
    //KALAU 1 LEVEL -> Push Replacement
    //KALAU SUB LEVEL -> Push (biasa)
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
            path: 'products',
            name: Routes.products,
            builder: (context, state) => const ProductsPage(),
            routes: [
              GoRoute(
                path: ':productid',
                name: Routes.detailProduct,
                builder: (context, state) => DetailProductPage(
                  state.pathParameters['productid'].toString(),
                  // state.uri.queryParameters,
                  state.extra as Products,
                ),
              ),
            ]),
        GoRoute(
          path: 'addproduct',
          name: Routes.addProduct,
          builder: (context, state) => AddProductPage(),
        ),
      ],
    ),

    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
  ],
);

GoRouter get router => _router;
