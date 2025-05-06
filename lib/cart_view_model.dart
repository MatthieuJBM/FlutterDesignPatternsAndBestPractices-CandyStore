import 'package:candy_store/cart_list_item.dart';
import 'package:candy_store/cart_model.dart';
import 'package:candy_store/product_list_item.dart';
import 'package:flutter/material.dart';

import 'cart_state.dart';

class CartViewModel extends ChangeNotifier {
  final CartModel _cartModel = CartModel();

  CartState _state = CartState(
    items: {},
    totalPrice: 0,
    totalItems: 0,
  );

  CartViewModel() {
    _cartModel.cartInfoStream.listen((cartInfo) {
      // TODO: Should actually copy the Map and not just the reference,
      // todo: which we will do at the end of this chapter.
      _state = _state.copyWith(
        items: cartInfo.items,
        totalPrice: cartInfo.totalPrice,
        totalItems: cartInfo.totalItems,
      );
      notifyListeners();
    });
  }

  CartState get state => _state;

  Future<void> addToCart(ProductListItem item) async {
    try {
      _state = _state.copyWith(isProcessing: true);
      notifyListeners();
      await _cartModel.addToCart(item);
      _state = _state.copyWith(isProcessing: false);
    } on Exception catch (ex) {
      _state = _state.copyWith(error: ex);
    }
    notifyListeners();
  }

  Future<void> removeFromCart(CartListItem item) async {
    try {
      _state = _state.copyWith(isProcessing: true);
      notifyListeners();
      await _cartModel.removeFromCart(item);
      _state = _state.copyWith(isProcessing: false);
    } on Exception catch (ex) {
      _state = _state.copyWith(error: ex);
    }
    notifyListeners();
  }

  void clearError() {
    _state = _state.copyWith(error: null);
    notifyListeners();
  }

  @override
  void dispose() {
    _cartModel.dispose();
    super.dispose();
  }
}
