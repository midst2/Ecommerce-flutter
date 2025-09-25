import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/models/cart_model.dart';

class MyBottomNavbar extends StatelessWidget {
  final void Function(int)? onTabChange;
  const MyBottomNavbar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: GNav(
        mainAxisAlignment: MainAxisAlignment.center,
        color: Colors.grey,
        activeColor: Colors.grey[800],
        tabBackgroundColor: const Color.fromARGB(255, 227, 227, 227),
        tabActiveBorder: Border.all(color: Colors.white),
        tabBorderRadius: 20,
        onTabChange: onTabChange,
        
        tabs: [
          GButton(icon: Icons.home, text: " Home"),
          // Cart with badge
          GButton(
            icon: Icons.shopping_cart,
            text: " My Cart",
            leading: Builder(
              builder: (context) {
                final count = context.watch<CartModel>().totalItems;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (count > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          GButton(icon: Icons.person, text: " Profile"),
        ],
      ),
    );
  }
}
