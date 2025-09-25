import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/models/cart_model.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "My Cart",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(Icons.shopping_cart, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100],
                        ),
                        height: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Image(
                                    image: AssetImage(item.imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text('\$${item.price}', style: TextStyle(color: Colors.grey[600])),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('x${item.quantity}'),
                                IconButton(
                                  onPressed: () {
                                    cart.removeItem(item);
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total (${cart.totalItems} items)', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${cart.totalPrice}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: cart.items.isEmpty ? null : () {
                    // proceed to checkout placeholder
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checkout not implemented')));
                  },
                  child: const Text('Checkout'),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: cart.items.isEmpty ? null : () {
                  cart.clear();
                },
                child: const Text('Clear'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
