import 'package:flutter/material.dart';
import 'package:myshop_udemy/screens/product_details.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../provider/cart.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProductDetails.routeName,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (context, product, _) => IconButton(
                icon: Icon(
                    product.isFavorite == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.orange),
                onPressed: () {
                  product.toggleFav();
                },
              ),
            ),
            backgroundColor: Colors.black54,
            title: Text(product.title),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.orange,
              ),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to cart!',
                      // textAlign: TextAlign.center,
                    ),
                    duration: Duration(
                      seconds: 3,
                    ),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
