// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panasonic/components/helper.dart';
import 'package:panasonic/constants.dart';
import 'package:panasonic/main.dart';
import 'package:panasonic/services/ProductServices.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String deviceName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 50,
        width: 80,
        child: MaterialButton(
          onPressed: () {
            Provider.of<ProviderVariables>(context, listen: false).product = null;
            Navigator.pushNamed(context, 'AddProductPage');
          },
          shape: RoundedRectangleBorder(borderRadius: KRadius),
          color: KPrimayColor,
          child: const Text('New Device', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        ),
      ),
      appBar: AppBar(backgroundColor: KPrimayColor),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(KPadding),
            child: TextField(
              onChanged: (data) {
                deviceName = data.toUpperCase().trim();
                setState(() {});
              },
              style: const TextStyle(fontSize: 18),
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                prefixStyle: TextStyle(color: Colors.black, fontSize: 18),
                hintText: 'Enter device name',
              ),
            ),
          ),

          // Devices List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(allProductsCollection).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  try {
                    return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      if (document.id.contains(deviceName)) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: KPadding, vertical: 8),
                              child: CustomButton(
                                onTap: () {
                                  Provider.of<ProviderVariables>(context, listen: false).product = ProductModel.fromFireStoreDB(data);
                                  Navigator.pushNamed(context, 'AddProductPage');
                                },
                                widget: Text(data['model'], style: const TextStyle(fontSize: 22)),
                                color: Colors.white,
                                borderColor: KPrimayColor,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Column();
                      }
                    }).toList());
                  } catch (e) {
                    return const Center(child: CircularProgressIndicator());
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

// zeyad@gmail.com

// 06062003