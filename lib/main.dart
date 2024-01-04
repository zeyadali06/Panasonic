// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Panasonic/NavigationBar.dart';
import 'package:Panasonic/constants.dart';
import 'package:Panasonic/firebase_options.dart';
import 'package:Panasonic/models/AccountDataModel.dart';
import 'package:Panasonic/models/ProductModel.dart';
import 'package:Panasonic/screens/AddProductPage.dart';
import 'package:Panasonic/screens/CompleteRegister.dart';
import 'package:Panasonic/screens/EditOrDeleteProductPage.dart';
import 'package:Panasonic/screens/SearchPage.dart';
import 'package:Panasonic/screens/SplachScreen.dart';
import 'package:Panasonic/screens/LoginPage.dart';
import 'package:Panasonic/screens/MyProductsPage.dart';
import 'package:Panasonic/screens/RegisterPage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return ProviderVariables();
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ProviderVariables>(context).dark
          ? // Dark
          ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.grey[700],
              textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
              appBarTheme: AppBarTheme(backgroundColor: Colors.grey[850], elevation: 0, shape: Border(bottom: BorderSide(color: Colors.grey[800]!))),
              buttonTheme: ButtonThemeData(colorScheme: ColorScheme.dark(scrim: Colors.white.withOpacity(.5), background: Colors.grey[850]!, outline: Colors.grey[700]!)),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.grey[900], selectedItemColor: Colors.blue, unselectedItemColor: Colors.grey),
              checkboxTheme: CheckboxThemeData(overlayColor: MaterialStateProperty.all(Colors.blue)),
              scaffoldBackgroundColor: Colors.grey[900],
            )
          : // Light
          ThemeData(
              brightness: Brightness.light,
              primaryColor: KPrimayColor,
              textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
              appBarTheme: const AppBarTheme(backgroundColor: KPrimayColor),
              buttonTheme: const ButtonThemeData(colorScheme: ColorScheme.light(scrim: KPrimayColor, background: Colors.white, outline: KPrimayColor)),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white, selectedItemColor: KPrimayColor, unselectedItemColor: Colors.grey[800]),
              checkboxTheme: CheckboxThemeData(overlayColor: MaterialStateProperty.all(KPrimayColor)),
            ),
      routes: {
        'SplachScreen': (context) => const SplachScreen(),
        'RegisterPage': (context) => const RegisterPage(),
        'CompleteRegisterPage': (context) => const CompleteRegisterPage(),
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
  ProductModel? product;

  late AccountData data;

  bool _dark = false;
  bool get dark => _dark;
  set dark(bool dark) {
    _dark = dark;
    notifyListeners();
  }
}
