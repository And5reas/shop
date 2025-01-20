import 'package:flutter/material.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping',
      theme: ThemeData(
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            secondary: Colors.deepOrange,
            primary: Colors.purple),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      routes: {
        AppRoutes.productDetail: (ctx) => const ProductDetailPage(),
      },
      home: ProductsOverviewPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
