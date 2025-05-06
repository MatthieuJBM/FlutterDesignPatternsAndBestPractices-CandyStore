import 'package:candy_store/cart_list_item_view.dart';
import 'package:candy_store/cart_view_model.dart';
import 'package:candy_store/cart_view_model_provider.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartViewModel _cartViewModel;

  @override
  void initState() {
    super.initState();
    // As you may recall, previously, we
    // accessed CartViewModelProvider via the .of method, and now it’s .read. The
    // difference in the implementation is that in the of method, we accessed InheritedWidget
    // via the depend method by running context.dependOnInheritedWidgetOfExactType<CartViewModelProvider>().
    // Remember, besides giving us a reference to the widget in question, it also subscribes the
    // calling widget to the changes in InheritedWidget. We can’t do that in initState
    // because it is called only once per life cycle. So, to just read InheritedWidget without
    // subscribing to its changes, BuildContext has another method:
    // context.getInheritedWidgetOfExactType<CartViewModelProvider>().
    // This is why we’re using it in the read method of CartViewModelProvider.

    // TODO THIS IS IMPORTANT!
    // When accessing InheritedWidget, you have two options:
    // You can rebuild the calling widget any time there are updates to the underlying
    // InheritedWidget. In this case, make sure you use the getter that calls
    // context.dependOnInheritedWidgetOfExactType<CartViewModelProvider>().
    // This can only be called in the methods that are invoked multiple times per life cycle, such as
    // build or didChangeDependencies.
    // You only access InheritedWidget once and don’t receive updates. In this case, make
    // sure you use the getter that calls
    // context.getInheritedWidgetOfExactType<CartViewModelProvider>(). It is
    // safe to call this method from initState.
    _cartViewModel = CartViewModelProvider.read(context);
    _cartViewModel.addListener(_onCartViewModelStateChanged);
  }

  @override
  void dispose() {
    _cartViewModel.dispose();
    super.dispose();
  }

  void _onCartViewModelStateChanged() {
    if (_cartViewModel.state.error != null) {
      _cartViewModel.clearError();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to perform this action')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListenableBuilder(
        listenable: _cartViewModel,
        builder: (context, _) {
          if (_cartViewModel.state.isProcessing) {
            return CircularProgressIndicator();
          } else {
            // return view without a progress
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _cartViewModel.state.items.length,
                    itemBuilder: (context, index) {
                      final item = _cartViewModel.state.items.values.toList()[index];
                      return CartListItemView(
                        item: item,
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${_cartViewModel.state.totalPrice} €',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
