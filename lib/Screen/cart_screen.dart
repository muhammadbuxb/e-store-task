import 'package:e_store/Model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? cart = prefs.getStringList('cart') ?? [];
      setState(() {
        cartItems = cart.map((item) => Product.fromJson(jsonDecode(item))).toList();
      });
      print('Cart items loaded successfully');
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final product = cartItems[index];
          return Card(
            color: Colors.white,
            elevation: 2,
            child: ListTile(
              leading: Image.asset(product.image),
              title: Text(product.name),
              subtitle: Text('\$${product.price}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    cartItems.removeAt(index);
                    saveCartItems();
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> saveCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cart = cartItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('cart', cart);
  }
}
