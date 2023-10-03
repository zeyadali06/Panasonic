// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:panasonic/NavigationBar.dart';
import 'package:panasonic/firebase_options.dart';
import 'package:panasonic/models/ProductModel.dart';
import 'package:panasonic/screens/AddProductPage.dart';
import 'package:panasonic/screens/EditOrDeleteProductPage.dart';
import 'package:panasonic/screens/SearchPage.dart';
import 'package:panasonic/screens/SplachScreen.dart';
import 'package:panasonic/screens/LoginPage.dart';
import 'package:panasonic/screens/MyProductsPage.dart';
import 'package:panasonic/screens/RegisterPage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChangeNotifierProvider(
      create: (context) {
        return ProviderVariables();
      },
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'SplachScreen': (context) => const SplachScreen(),
        'RegisterPage': (context) => const RegisterPage(),
        'LoginPage': (context) => const LoginPage(),
        'MyProductsPage': (context) => const MyProductsPage(),
        'SearchPage': (context) => const SearchPage(),
        'AddProductPage': (context) => const AddProductPage(),
        'EditOrDeleteProductPage': (context) => const EditOrDeleteProductPage(),
        'HomeNavigationBar': (context) => const HomeNavigationBar(),
      },
      home: const SplachScreen(),
    );
  }
}

class ProviderVariables extends ChangeNotifier {
  String? email;
  String? username;

  ProductModel? product;
}
