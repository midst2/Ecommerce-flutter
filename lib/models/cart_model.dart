import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final int price;
  final String imagePath;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    // if same item exists, increase quantity
    final idx = _items.indexWhere((e) => e.name == item.name);
    if (idx >= 0) {
      _items[idx].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.removeWhere((e) => e.name == item.name);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get totalItems => _items.fold(0, (s, e) => s + e.quantity);

  int get totalPrice => _items.fold(0, (s, e) => s + e.price * e.quantity);
}
