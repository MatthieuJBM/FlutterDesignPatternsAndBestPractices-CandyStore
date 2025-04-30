import 'package:candy_store/cart_button.dart';
import 'package:candy_store/cart_list_item.dart';
import 'package:candy_store/cart_notifier.dart';
import 'package:candy_store/cart_page.dart';
import 'package:candy_store/products_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CartNotifier cartNotifier = CartNotifier();
  final List<CartListItem> cartItems = [];

  // The Map key is the id of the CartListItem. We will use a Map data structure
  // because it is easier to manage the addition, removal & count of the items.
  // final Map<String, CartListItem> cartItemsMap = {};
  ValueNotifier<Map<String, CartListItem>> items = ValueNotifier({});

  @override
  void initState() {
    super.initState();
    cartNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    cartNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProductsPage(
          onAddToCart: cartNotifier.addToCart,
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: GestureDetector(
            onTap: openCart,
            child: CartButton(
              count: cartNotifier.totalItems,
            ),
          ),
        ),
      ],
    );
  }

  void openCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartPage(
          cartNotifier: cartNotifier,
          items: items,
        ),
      ),
    );
  }
}
