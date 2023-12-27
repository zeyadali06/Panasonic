// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:panasonic/components/helper.dart';
import 'package:panasonic/constants.dart';
import 'package:panasonic/main.dart';
import 'package:provider/provider.dart';

class CompleteRegisterPage extends StatefulWidget {
  const CompleteRegisterPage({super.key});

  @override
  State<CompleteRegisterPage> createState() => _CompleteRegisterPageState();
}

class _CompleteRegisterPageState extends State<CompleteRegisterPage> {
  late String username;
  late String phone;
  bool isLoading = false;

  GlobalKey<FormState> usernameKey = GlobalKey();
  GlobalKey<FormState> phoneKey = GlobalKey();
  GlobalKey<FormState> allKey = GlobalKey();

  AutovalidateMode mode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(KHorizontalPadding),
            child: Form(
              key: allKey,
              autovalidateMode: mode,
              child: Column(
                children: [
                  // Animation
                  const SizedBox(height: 20),
                  Lottie.asset('assets/animated_images/animation_llz60pig.json'),

                  // Panasonic
                  const SizedBox(height: 15),
                  const Text('Panasonic', style: TextStyle(fontSize: 45, color: KPrimayColor, fontWeight: FontWeight.w900)),

                  // Complete Register
                  const SizedBox(height: 50),
                  const Row(
                    children: [
                      Text('Complete Registration', style: TextStyle(color: KPrimayColor, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  // Username
                  const SizedBox(height: 25),
                  CustomTextFormField(
                    prefixIcon: Icons.person,
                    label: 'Username',
                    hintText: 'Username',
                    onSaved: (value) {
                      username = value!;
                    },
                    onChanged: (value) {},
                  ),

                  // Phone
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    prefixIcon: Icons.phone,
                    label: 'Phone',
                    hintText: 'Phone',
                    onSaved: (value) {
                      phone = value!;
                    },
                    onChanged: (value) {},
                  ),

                  // Complete Registeration
                  const SizedBox(height: 10),
                  CustomButton(
                    color: KPrimayColor,
                    borderColor: KPrimayColor,
                    widget: const Text('Complete Registeration', style: TextStyle(color: Colors.white, fontSize: 22)),
                    onTap: () async {
                      if (allKey.currentState!.validate()) {
                        allKey.currentState!.save();

                        setState(() {
                          isLoading = true;
                        });

                        var usernameChecker = await FirebaseFirestore.instance.collection(usernameCollection).where('username', isEqualTo: username).limit(1).get();
                        if (usernameChecker.docs.isNotEmpty) {
                          setState(() {
                            isLoading = false;
                          });
                          showSnackBar(context, 'Username Already Exist');
                        } else {
                          Provider.of<ProviderVariables>(context, listen: false).data.username = username;
                          Provider.of<ProviderVariables>(context, listen: false).data.phone = phone;

                          await FirebaseFirestore.instance
                              .collection(usernameCollection)
                              .doc(Provider.of<ProviderVariables>(context, listen: false).data.uid)
                              .set(Provider.of<ProviderVariables>(context, listen: false).data.toMap(), SetOptions(merge: true));

                          Navigator.pushNamedAndRemoveUntil(context, 'HomeNavigationBar', (route) => false);
                        }

                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        mode = AutovalidateMode.always;
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
