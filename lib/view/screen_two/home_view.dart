import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_project/utils/router.dart';
import 'package:test_project/view/screen_two/login_view.dart';

import '../../services/firebase_services.dart';


class HomeView extends StatelessWidget {
  HomeView({super.key});

  final FirebaseService _service = FirebaseService();

  void _logout(BuildContext context) async {
    await _service.signOut();
    if(!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginView()),
    );
  }

  void _addProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (contxt) => AlertDialog(
        title: const Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Stock Count'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await _service.addProduct(
                name: nameController.text,
                price: double.tryParse(priceController.text) ?? 0,
                stockCount: int.tryParse(stockController.text) ?? 0,
              );
              
              
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editProductDialog(BuildContext context, String productId, Map<String, dynamic> product) {
    final nameController = TextEditingController(text: product['name']);
    final priceController = TextEditingController(text: product['price'].toString());
    final stockController = TextEditingController(text: product['stockCount'].toString());

    showDialog(
      context: context,
      builder: (contxt) => AlertDialog(
        title: const Text('Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Stock Count'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => AppRouter.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
             
              await _service.updateProduct(
                productId: productId,
                name: nameController.text,
                price: double.tryParse(priceController.text) ?? product['price'],
                stockCount: int.tryParse(stockController.text) ?? product['stockCount'],
              );
             
              
              // if(context.mounted){
                
              // }
              
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Products', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: Colors.white,),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addProductDialog(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(data['name']),
                  subtitle: Text('Price: ${data['price']} | Stock: ${data['stockCount']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editProductDialog(context, doc.id, data),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red,),
                        onPressed: () => _service.deleteProduct(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
