import 'package:flutter/material.dart';
import 'package:myshop_udemy/screens/edit_product_screen.dart';
import 'package:myshop_udemy/widgets/app_drawer.dart';
import 'package:myshop_udemy/widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  const UserProductScreen({Key? key}) : super(key: key);
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
              );
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (context, index) => Column(
                    children: [
                      UserProductItem(
                        id: productsData.items[index].id,
                        title: productsData.items[index].title,
                        imgUrl: productsData.items[index].imageUrl,
                      ),
                      Divider()
                    ],
                  )),
        ),
      ),
    );
  }
}
