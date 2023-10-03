// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:panasonic/components/helper.dart';
import 'package:panasonic/constants.dart';
import 'package:panasonic/main.dart';
import 'package:panasonic/models/ProductModel.dart';
import 'package:panasonic/services/ProductServices.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: KPrimayColor,
          centerTitle: true,
          title: const Text('My Products', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                onPressed: () {
                  nullingProductDetails(context);
                  Navigator.pushNamed(context, 'AddProductPage');
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(usersCollection).snapshots(),
          builder: (context, snapshot) {
            List<Map<bool, ProductModel>> myProducts = [];

            if (snapshot.hasData) {
              try {
                myProducts = getProductsData(context, snapshot);
                if (myProducts.isEmpty) {
                  return const Center(child: Text('No Devices Found', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
                }
              } catch (e) {
                return const Center(child: Text('No Devices Found', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
              }
              try {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: myProducts.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: KHorizontalPadding, vertical: 8),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: KRadius),
                            child: ListTile(
                              title: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Delete Product ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
                                  Icon(Icons.delete, color: Colors.white),
                                ],
                              ),
                              tileColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: KRadius),
                            ),
                          ),
                          Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              isLoading = true;
                              setState(() {});
                              await deleteProduct(e.values.single, context);
                              isLoading = false;
                              setState(() {});
                            },
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(side: const BorderSide(width: 2, color: KPrimayColor), borderRadius: KRadius),
                              child: ListTile(
                                onTap: () {
                                  isLoading = true;
                                  setState(() {});
                                  Provider.of<ProviderVariables>(context, listen: false).product = e.values.single;
                                  Navigator.pushNamed(context, 'EditOrDeleteProductPage');
                                  isLoading = false;
                                  setState(() {});
                                },
                                leading: Text(e.values.single.model, style: const TextStyle(fontSize: 22)),
                                title: e.values.single.price == null ? null : Center(child: Text("${e.values.single.price}£E", style: const TextStyle(fontSize: 22))),
                                trailing: Text(e.keys.single ? 'used' : ''),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              } catch (e) {
                return const Center(child: CircularProgressIndicator());
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

List<Map<bool, ProductModel>> getProductsData(BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
  List<Map<bool, ProductModel>> myProducts = [];

  Map<String, dynamic> data = snapshot.data!.docs
      .where((element) {
        if (element.id == Provider.of<ProviderVariables>(context, listen: false).email) {
          return true;
        } else {
          return false;
        }
      })
      .single
      .data() as Map<String, dynamic>;
  data.forEach((key, value) {
    myProducts.add({key[key.length - 1] == 't' ? true : false: ProductModel.fromFireStoreDB(value)});
  });

  return myProducts;
}



// zeyad@gmail.com

// 06062003


// zeyadali6060@gmail.com

// Ze06062003#


// set@gmail.com

// set.com