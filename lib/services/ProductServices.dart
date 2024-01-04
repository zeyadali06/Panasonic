// ignore_for_file: file_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Panasonic/constants.dart';
import 'package:Panasonic/main.dart';
import 'package:Panasonic/models/ProductModel.dart';
import 'package:provider/provider.dart';

Future<void> addProduct({required ProductModel product}) async {
  await FirebaseFirestore.instance.collection(allProductsCollection).doc(product.model).set({
    'model': product.model.toUpperCase(),
    'description': product.description,
    'category': product.category,
    'used': product.used,
    'price': product.price,
    'quantity': product.quantity,
    'image': product.image,
    'abbreviation': product.abbreviation?.toUpperCase(),
    'compatibility': product.compatibility,
    'note': product.note,
  });
}

Future<void> addProductToAccount({required ProductModel product, required String email}) async {
  try {
    await FirebaseFirestore.instance.collection(usersCollection).doc(email).update({
      '${product.model}${product.used ? 't' : 'f'}': {
        'model': product.model.toUpperCase(),
        'description': product.description,
        'category': product.category,
        'used': product.used,
        'price': product.price,
        'quantity': product.quantity,
        'image': product.image,
        'abbreviation': product.abbreviation?.toUpperCase(),
        'compatibility': product.compatibility,
        'note': product.note,
      }
    });
  } catch (e) {
    await FirebaseFirestore.instance.collection(usersCollection).doc(email).set({
      '${product.model}${product.used ? 't' : 'f'}': {
        'model': product.model.toUpperCase(),
        'description': product.description,
        'category': product.category,
        'used': product.used,
        'price': product.price,
        'quantity': product.quantity,
        'image': product.image,
        'abbreviation': product.abbreviation?.toUpperCase(),
        'compatibility': product.compatibility,
        'note': product.note,
      }
    });
  }
}

Future<ProductModel> getProduct({String? model, String? abbreviation, required String collection}) async {
  // you should pass model or abbreviation
  if ((model == null && abbreviation == null) || (model != null && abbreviation != null)) {
    throw Exception("you should pass a value to model or abbreviation and not both");
  }

  final iter = StreamIterator(FirebaseFirestore.instance.collection(collection).snapshots());
  await iter.moveNext();
  dynamic product;

  if (model != null) {
    for (var element in iter.current.docs) {
      if (element['model'] == model) {
        product = element;
      }
    }
  } else if (abbreviation != null) {
    for (var element in iter.current.docs) {
      if (element['abbreviation'] == abbreviation) {
        product = element;
      }
    }
  }

  return ProductModel(
    model: product['model'].toString().toUpperCase(),
    description: product['description'],
    category: product['category'],
    used: product['used'],
    price: product['price'],
    quantity: product['quantity'],
    abbreviation: product['abbreviation'].toString().toUpperCase(),
    compatibility: product['compatibility'],
    image: product['image'],
    note: product['note'],
  );
}

String data(ProductModel pm) {
  return """
    *************************************************
    model: ${pm.model}\n
    description: ${pm.description}\n
    category: ${pm.category}\n
    used: ${pm.used}\n
    price: ${pm.price}\n
    quantity: ${pm.quantity}\n
    abbreviation: ${pm.abbreviation}\n
    compatibility: ${pm.compatibility}\n
    image: ${pm.image}\n
    note: ${pm.note}\n
    *************************************************
    """;
}

Future<void> deleteProduct(ProductModel pm, BuildContext context) async {
  final updates = <String, dynamic>{
    '${pm.model}${pm.used ? 't' : 'f'}': FieldValue.delete(),
  };
  await FirebaseFirestore.instance.collection(usersCollection).doc(Provider.of<ProviderVariables>(context, listen: false).data.email).update(updates);
}
