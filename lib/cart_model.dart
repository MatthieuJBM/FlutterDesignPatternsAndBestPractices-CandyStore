import 'dart:async';

import 'package:candy_store/cart_info.dart';
import 'package:candy_store/cart_list_item.dart';
import 'package:candy_store/product_list_item.dart';

class CartModel {
  CartModel._internal();

  static final CartModel _instance = CartModel._internal();

  factory CartModel() => _instance;

  CartInfo _cartInfo = CartInfo(
    items: {},
    totalPrice: 0,
    totalItems: 0,
  );

  CartInfo get cartInfo => _cartInfo;

  final StreamController<CartInfo> _cartInfoController = StreamController<CartInfo>.broadcast();

  Stream<CartInfo> get cartInfoStream => _cartInfoController.stream;

  Future<CartInfo> get cartInfoFuture async => _cartInfo.copyWith(
        items: Map.unmodifiable(_cartInfo.items),
      );

  Future<void> addToCart(ProductListItem item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    CartListItem? existingItem = _cartInfo.items[item.id];
    if (existingItem != null) {
      existingItem = CartListItem(
        product: existingItem.product,
        quantity: existingItem.quantity + 1,
      );
      _cartInfo.items[item.id] = existingItem;
    } else {
      final cartItem = CartListItem(
        product: item,
        quantity: 1,
      );
      _cartInfo.items[item.id] = cartItem;
    }
    _cartInfo.totalItems++;
    _cartInfo.totalPrice += item.price;

    /// By creating a new instance we are ensuring a new object instnace is emitted.
    /// Flutter will know to rebuild widgets, because the data is new by identity (not just by content).
    final cartInfo = _cartInfo.copyWith(
      items: Map.unmodifiable(_cartInfo.items),
    );

    /// The stream based on this StreamController will only rebuild if the stream emits a new object.
    /// if we make a call like _cartInfoController.add(_cartInfo); and _cartInfo is the same instance
    /// as before, some reactive systems like Streambuilder might not detect any change, even if
    /// the data inside changed.
    _cartInfoController.add(cartInfo);
  }

  Future<void> removeFromCart(CartListItem item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // throw Exception('Could not remove item from cart')
    CartListItem? existingItem = _cartInfo.items[item.product.id];
    if (existingItem != null) {
      if (existingItem.quantity > 1) {
        existingItem = CartListItem(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        );
        _cartInfo.items[item.product.id] = existingItem;
      } else {
        _cartInfo.items.remove(item.product.id);
      }
    }
    _cartInfo.totalItems--;
    _cartInfo.totalPrice -= item.product.price;

    final cartInfo = _cartInfo.copyWith(
      items: Map.unmodifiable(_cartInfo.items),
    );

    _cartInfoController.add(cartInfo);
  }

  void dispose() {
    _cartInfoController.close();
  }
}
