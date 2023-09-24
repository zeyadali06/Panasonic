// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:panasonic/components/helper.dart';
import 'package:panasonic/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KPrimayColor,
        centerTitle: true,
        title: const Text('Panasonic', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(KPadding),
        child: Column(
          children: [
            // My Products
            CustomButton(
              onTap: () {
                Navigator.pushNamed(context, 'MyProductsPage');
              },
              widget: textOfCustomButton(text: 'My Products'),
              color: KPrimayColor,
              borderColor: KPrimayColor,
            ),
            const SizedBox(height: 10),
            // Add Product
            CustomButton(
              onTap: () {
                Navigator.pushNamed(context, 'SearchPage');
              },
              widget: textOfCustomButton(text: 'Add Product'),
              color: KPrimayColor,
              borderColor: KPrimayColor,
            ),
          ],
        ),
      ),
    );
  }
}
