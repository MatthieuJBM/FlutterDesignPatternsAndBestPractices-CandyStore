import 'package:candy_store/cart_notifier.dart';
import 'package:flutter/material.dart';

class CartProvider extends InheritedWidget {
  final CartNotifier cartNotifier;

  CartProvider({
    super.key,
    required this.cartNotifier,
    required Widget child,
  }) : super(child: child);

  static CartNotifier of(BuildContext context) {
    final CartProvider? provider = context.dependOnInheritedWidgetOfExactType<CartProvider>();
    if (provider == null) {
      throw Exception('No CartProvider found in context');
    }
    return provider.cartNotifier;
  }

  @override
  bool updateShouldNotify(CartProvider oldWidget) {
    return cartNotifier != oldWidget.cartNotifier;
  }
}
