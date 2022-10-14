import 'package:flutter/material.dart';
import 'package:myshop_udemy/provider/cart.dart';
import 'package:myshop_udemy/provider/order.dart';
import 'package:myshop_udemy/provider/products.dart';
import 'package:myshop_udemy/screens/cart_screen.dart';
import 'package:myshop_udemy/screens/edit_product_screen.dart';
import 'package:myshop_udemy/screens/orders_screen.dart';
import 'package:myshop_udemy/screens/product_details.dart';
import 'package:myshop_udemy/screens/product_overview.dart';
import 'package:myshop_udemy/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Products(),
          ),
          ChangeNotifierProvider(
            create: (_) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (_) => Orders(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
              //  primaryColor: Colors.tealAccent,
              // primarySwatch: Colors.orange,
              ),
          routes: {
            CartScreen.routeName: (context) => CartScreen(),
            ProductDetails.routeName: (context) => ProductDetails(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen()
          },
          home: ProductOverview(),
        ));
  }
}
