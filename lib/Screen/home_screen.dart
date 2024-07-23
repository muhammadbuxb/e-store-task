import 'package:e_store/Model/product_model.dart';
import 'package:e_store/Screen/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, IconData> categories = {
    'Men': Icons.male,
    'Kids': Icons.child_care,
    'Women': Icons.female,
    'Electronics': Icons.electrical_services,
    'Mobiles': Icons.phone_android,
  };

  final Map<String, List<Product>> categoryProducts = {
    'Men': List.generate(
        7,
        (index) => Product(
            name: 'Men Product $index',
            image: 'assets/mens.jpeg',
            rating: 4.5,
            price: 99.99)),
    'Kids': List.generate(
        5,
        (index) => Product(
            name: 'Kids Product $index',
            image: 'assets/kids.jpeg',
            rating: 4.5,
            price: 49.99)),
    'Women': List.generate(
        5,
        (index) => Product(
            name: 'Women Product $index',
            image: 'assets/womens.jpeg',
            rating: 4.5,
            price: 89.99)),
    'Electronics': List.generate(
        5,
        (index) => Product(
            name: 'Electronics Product $index',
            image: 'assets/electronics.jpeg',
            rating: 4.5,
            price: 199.99)),
    'Mobiles': List.generate(
        5,
        (index) => Product(
            name: 'Mobile Product $index',
            image: 'assets/mobiles.jpeg',
            rating: 4.5,
            price: 299.99)),
  };

  String selectedCategory = 'Men';

  Future<void> addToCart(Product product) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? cart = prefs.getStringList('cart') ?? [];
      cart.add(jsonEncode(product.toJson()));
      await prefs.setStringList('cart', cart);
      print('Product added to cart: ${product.name}');
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E-Store',
          style: TextStyle(
              fontSize: 22,
              color: Colors.green.shade400,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              size: 30,
              color: Colors.green.shade400,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              
              child: Text('Categories'),
              decoration: BoxDecoration(
                color: Colors.green.shade300,
              ),
            ),
            ...categories.keys.map((category) => ListTile(
                  leading: Icon(categories[category]),
                  title: Text(category),
                  selected: category == selectedCategory,
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 600)
            NavigationRail(
              indicatorColor: Colors.green.shade200,
              destinations: categories.keys
                  .map((category) => NavigationRailDestination(
                        icon: Icon(categories[category]),
                        label: Text(category),
                      ))
                  .toList(),
              selectedIndex: categories.keys.toList().indexOf(selectedCategory),
              onDestinationSelected: (index) {
                setState(() {
                  selectedCategory = categories.keys.toList()[index];
                });
              },
            ),
          Expanded(child: buildGridView()),
        ],
      ),
    );
  }

  Widget buildGridView() {
    final products = categoryProducts[selectedCategory] ?? [];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return buildProductCard(products[index]);
        },
      ),
    );
  }

  Widget buildProductCard(Product product) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            product.image,
            height: MediaQuery.of(context).size.height/4,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
            child: Text(
              product.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 16),
                SizedBox(
                  width: 10,
                ),
                Text('${product.rating}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${product.price}', style: TextStyle(fontSize: 16)),
                ElevatedButton(
                  onPressed: () async {
                    await addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to Cart')),
                    );
                  },
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.green.shade400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
