import 'package:candy_store/cart_button.dart';
import 'package:candy_store/cart_list_item.dart';
import 'package:candy_store/cart_page.dart';
import 'package:candy_store/product_list_item.dart';
import 'package:candy_store/products_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<CartListItem> cartItems = [];

  // The Map key is the id of the CartListItem. We will use a Map data structure
  // because it is easier to manage the addition, removal & count of the items.
  final Map<String, CartListItem> cartItemsMap = {};

  @override
  Widget build(BuildContext context) {
    final totalCount = cartItemsMap.values.fold<int>(
      0,
      (previousValue, element) => previousValue + element.quantity,
    );

    return Stack(
      children: [
        ProductsPage(
          onAddToCart: addToCart,
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: GestureDetector(
            onTap: openCart,
            child: CartButton(
              count: totalCount,
            ),
          ),
        ),
      ],
    );
  }

  void addToCart(ProductListItem item) {
    setState(() {
      cartItemsMap.update(
        item.id,
        (existingItem) => CartListItem(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        ),
        ifAbsent: () => CartListItem(
          product: item,
          quantity: 1,
        ),
      );
    });
  }

  void removeFromCart(CartListItem item) {
    setState(() {
      final CartListItem? existingItem = cartItemsMap[item.product.id];
      if (existingItem == null) return;

      if (existingItem.quantity > 1) {
        cartItemsMap.update(
          item.product.id,
          (existingItem) => CartListItem(
            product: existingItem.product,
            quantity: existingItem.quantity - 1,
          ),
        );
      } else {
        cartItemsMap.remove(item.product.id);
      }
    });
  }

  void openCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartPage(
          items: cartItemsMap.values.toList(),
          onAddToCart: (item) {
            addToCart(item.product);
          },
          onRemoveFromCart: removeFromCart,
        ),
      ),
    );
  }
}
