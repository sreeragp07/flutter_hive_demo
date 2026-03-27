import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_demo/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isLoading = false;
  List<Product> products = [];

  final box = Hive.box<Product>("products");

  loadProducts() {
    final list = box.values.toList();
    products.clear();
    products.addAll(list);
    setState(() {});
  }

  addProduct() async {
    setState(() {
      isLoading = true;
    });
    final name = nameController.text.trim();
    final price = priceController.text.trim();

    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the required fields")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    await Future.delayed(Duration(seconds: 2));

    await box.add(Product(name: name, price: price));

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Product successfully added")));

    loadProducts();

    nameController.clear();
    priceController.clear();

    setState(() {
      isLoading = false;
    });
  }

  deleteProduct(int index) async {
    await box.deleteAt(index);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Product deleted successfully ")));
    loadProducts();
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hive Demo App",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text("Name"),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                label: Text("Price"),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
              },
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => addProduct(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Text(
                        "Add Product",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              "Products",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            products.isEmpty
                ? Center(child: Text("No products available"))
                : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: ListTile(
                            title: Text(products[index].name),
                            subtitle: Text("Rs. ${products[index].price}"),
                            trailing: GestureDetector(
                              onTap: () => deleteProduct(index),
                              child: Icon(Icons.delete),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
