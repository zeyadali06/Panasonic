// ignore_for_file: file_names

import 'package:Panasonic/main.dart';
import 'package:Panasonic/models/AccountDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:Panasonic/constants.dart';
import 'package:provider/provider.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> with SingleTickerProviderStateMixin {
  var listener;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    listener = InternetConnectionChecker().onStatusChange.listen((status) async {
      switch (status) {
        case InternetConnectionStatus.connected:
          await Future.delayed(const Duration(seconds: 2));
          if (FirebaseAuth.instance.currentUser == null) {
            Navigator.pushReplacementNamed(context, 'LoginPage');
          } else {
            var userdata = await FirebaseFirestore.instance.collection(usernameCollection).doc(FirebaseAuth.instance.currentUser!.uid).get();
            Provider.of<ProviderVariables>(context, listen: false).data = AccountData.fromFireStore(userdata.data());
            Provider.of<ProviderVariables>(context, listen: false).dark = Provider.of<ProviderVariables>(context, listen: false).data.dark;
            Navigator.pushReplacementNamed(context, 'HomeNavigationBar');
          }
          break;
        case InternetConnectionStatus.disconnected:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Internet', style: TextStyle(fontSize: 20, color: KPrimayColor, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              duration: Duration(seconds: 8),
            ),
          );
          break;
      }
    });
  }

  @override
  void dispose() async {
    cancelListener();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Future<void> cancelListener() async {
    await listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KPrimayColor,
      body: Center(
        child: AnimatedTextKit(
          isRepeatingAnimation: false,
          pause: const Duration(milliseconds: 0),
          animatedTexts: [
            TypewriterAnimatedText(
              'Panasonic',
              cursor: '',
              curve: Curves.elasticOut,
              speed: const Duration(milliseconds: 250),
              textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
