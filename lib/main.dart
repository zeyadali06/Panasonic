// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:panasonic/NavigationBar.dart';
import 'package:panasonic/firebase_options.dart';
import 'package:panasonic/screens/AddProductPage.dart';
import 'package:panasonic/screens/EditOrDeleteProductPage.dart';
import 'package:panasonic/screens/SearchPage.dart';
import 'package:panasonic/screens/SplachScreen.dart';
import 'package:panasonic/screens/HomePage.dart';
import 'package:panasonic/screens/LoginPage.dart';
import 'package:panasonic/screens/MyProductsPage.dart';
import 'package:panasonic/screens/RegisterPage.dart';
import 'package:panasonic/services/ProductServices.dart';
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
        'HomePage': (context) => const HomePage(),
        'RegisterPage': (context) => const RegisterPage(),
        'LoginPage': (context) => const LoginPage(),
        'MyProductsPage': (context) => const MyProductsPage(),
        'SearchPage': (context) => const SearchPage(),
        'AddProductPage': (context) => const AddProductPage(),
        'EditOrDeleteProductPage': (context) => const EditOrDeleteProductPage(),
        'NavBar': (context) => const NavBar(),
      },
      home: const SplachScreen(),
    );
  }
}

class ProviderVariables extends ChangeNotifier {
  String? email;

  ProductModel? product;
  bool? used;
  String? category;
  Set<dynamic>? compatibility;
}
