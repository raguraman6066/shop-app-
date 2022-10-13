import 'package:flutter/material.dart';
import 'package:myshop_udemy/provider/products.dart';
import 'package:myshop_udemy/screens/cart_screen.dart';
import 'package:myshop_udemy/widgets/app_drawer.dart';
import 'package:myshop_udemy/widgets/product_grid.dart';
import 'package:provider/provider.dart';
import 'package:myshop_udemy/widgets/badge.dart';

import '../provider/cart.dart';

enum FilterOption {
  Favorite,
  All,
}

var showFav = false;

class ProductOverview extends StatefulWidget {
  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final products = showFav ? productData.favItems : productData.items;
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selectedValue) {
                setState(() {
                  if (selectedValue == FilterOption.Favorite) {
                    showFav = true;
                  } else {
                    showFav = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert), //icon
              itemBuilder: (_) => [
                    //build inside
                    const PopupMenuItem(
                      child: Text('Only Favorite'),
                      value: FilterOption.Favorite,
                    ),
                    const PopupMenuItem(
                      child: Text('Show all'),
                      value: FilterOption.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (context, cartData, _) => Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
              value: cartData.itemCount.toString(),
              color: Colors.red,
            ),
          )
        ],
        title: Text('My Shop'),
      ),
      drawer: AppDrawer(),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index], //single product comes
          child: ProductGrid(),
        ),
      ),
    );
  }
}
