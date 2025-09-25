import 'package:ecommerce/components/my_app_bar.dart';
import 'package:ecommerce/components/my_bottom_navbar.dart';
import 'package:ecommerce/pages/public/logged_out_page.dart';
import 'package:ecommerce/pages/public/my_cart_page.dart';
import 'package:ecommerce/pages/private/profile_page.dart';
import 'package:ecommerce/pages/public/shop_page.dart';
import 'package:ecommerce/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const ShopPage(),
      const MyCartPage(),
      StreamBuilder<User?>(
        stream: AuthService.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data ?? AuthService.currentUser;
          return user != null ? const ProfilePage() : const LoggedOutPage();
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(index: _selectedIndex),
      drawer: const Drawer(),
      body: pages[_selectedIndex],
      bottomNavigationBar: MyBottomNavbar(onTabChange: navigateBottomBar),
    );
  }
}
