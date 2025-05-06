import 'dart:async';

import 'package:candy_store/cart_info.dart';
import 'package:candy_store/product_list_item.dart';

import 'cart_list_item.dart';

class CartModel {
  final CartInfo _cartInfo = CartInfo(
    items: {},
    totalPrice: 0,
    totalItems: 0,
  );

  CartInfo get cartInfo => _cartInfo;

  final StreamController<CartInfo> _cartInfoController = StreamController<CartInfo>();

  Stream<CartInfo> get cartInfoStream => _cartInfoController.stream;

  Future<CartInfo> get cartInfoFuture async => _cartInfo;

  Future<void> addToCart(ProductListItem item) async {
    await Future.delayed(const Duration(seconds: 3));
    //throw Exception('Could not add item to the cart');
    _cartInfo.items.update(
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
    _cartInfo.totalItems++;
    _cartInfo.totalPrice += item.price;

    _cartInfoController.add(_cartInfo);
  }

  Future<void> removeFromCart(CartListItem item) async {
    await Future.delayed(const Duration(seconds: 3));
    //throw Exception('Could not remove item from the cart');

    final CartListItem? existingItem = _cartInfo.items[item.product.id];
    if (existingItem == null) return;

    if (existingItem.quantity > 1) {
      _cartInfo.items.update(
        item.product.id,
        (existingItem) => CartListItem(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _cartInfo.items.remove(item.product.id);
    }
    _cartInfo.totalItems--;
    _cartInfo.totalPrice -= item.product.price;

    _cartInfoController.add(_cartInfo);
  }

  void dispose() {
    _cartInfoController.close();
  }
}
