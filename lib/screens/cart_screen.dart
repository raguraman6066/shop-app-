import 'package:flutter/material.dart';
import 'package:myshop_udemy/provider/order.dart';
import 'package:provider/provider.dart';
import 'package:myshop_udemy/widgets/cart_item.dart' as ci;

import '../provider/cart.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount}'),
                    backgroundColor: Colors.pink,
                  ),
                  orderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) => ci.CartItemWidget(
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title,
                quantity: cart.items.values.toList()[index].quantity,
                price: cart.items.values.toList()[index].price.toString()),
          )),
        ],
      ),
    );
  }
}

class orderButton extends StatefulWidget {
  const orderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<orderButton> createState() => _orderButtonState();
}

class _orderButtonState extends State<orderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  total: widget.cart.totalAmount,
                  cartProducts: widget.cart.items.values.toList());
              setState(() {
                isLoading = false;
              });
              widget.cart.clear();
            },
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text(
              "Order Now",
            ),
      style: TextButton.styleFrom(primary: Colors.pink),
    );
  }
}
