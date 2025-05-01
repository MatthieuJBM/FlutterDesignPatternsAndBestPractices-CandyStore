import 'package:candy_store/cart_list_item.dart';
import 'package:candy_store/product_list_item.dart';
import 'package:flutter/cupertino.dart';

class CartNotifier extends ChangeNotifier {
  final Map<String, CartListItem> _items = {};
  double _totalPrice = 0;
  int _totalItems = 0;

  List<CartListItem> get items => _items.values.toList();

  double get totalPrice => _totalPrice;

  int get totalItems => _totalItems;

  void addToCart(ProductListItem item) {
    _items.update(
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
    _totalItems++;
    _totalPrice += item.price;

    notifyListeners();
  }

  void removeFromCart(CartListItem item) {
    final CartListItem? existingItem = _items[item.product.id];
    if (existingItem == null) return;

    if (existingItem.quantity > 1) {
      _items.update(
        item.product.id,
        (existingItem) => CartListItem(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(item.product.id);
    }
    _totalItems--;
    _totalPrice -= item.product.price;

    notifyListeners();
  }
}
