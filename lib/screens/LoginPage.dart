// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:Panasonic/models/AccountDataModel.dart';
import 'package:Panasonic/services/Registration.dart';
import 'package:Panasonic/components/helper.dart';
import 'package:Panasonic/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:Panasonic/main.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? emailOrUsername;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode mode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Form(
            key: formKey,
            autovalidateMode: mode,
            child: ListView(
              children: [
                // Animation
                const SizedBox(height: 20),
                Lottie.asset('assets/animated_images/animation_llz60pig.json'),

                Padding(
                  padding: const EdgeInsets.all(KHorizontalPadding),
                  child: Column(
                    children: [
                      // Panasonic
                      const Center(child: Text('Panasonic', style: TextStyle(fontSize: 45, fontWeight: FontWeight.w900, color: KPrimayColor))),
                      const SizedBox(height: 50),

                      // Log In
                      const Row(children: [Center(child: Text('Log In', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: KPrimayColor)))]),
                      const SizedBox(height: 25),

                      // Email Or Username
                      CustomTextFormField(
                        prefixIcon: Icons.email,
                        label: 'Email or Username',
                        hintText: 'Enter Your Email or Username',
                        onSaved: (value) {
                          emailOrUsername = value;
                        },
                        onChanged: (data) {},
                      ),
                      const SizedBox(height: 10),

                      // Password
                      CustomTextFormField(
                        prefixIcon: Icons.lock_outlined,
                        label: 'Password',
                        hintText: 'Enter Your Password',
                        obscureText: true,
                        onChanged: (data) {},
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Login Button
                      CustomButton(
                        color: KPrimayColor,
                        borderColor: KPrimayColor,
                        widget: const Text('Login', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            formKey.currentState!.save();
                            await loginNormally(context, emailOrUsername!, password!);
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            mode = AutovalidateMode.always;
                            setState(() {});
                          }
                        },
                      ),

                      // Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, 'RegisterPage');
                              },
                              child: const Text('Register!', style: TextStyle(fontStyle: FontStyle.italic, color: KPrimayColor, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Sign in with Google
                      GDForSignInMethods(
                        color: const Color.fromARGB(255, 230, 230, 230),
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            UserCredential user = await SignIn.signInWithGoogle();

                            var getData = await FirebaseFirestore.instance.collection(usernameCollection).where('uid', isEqualTo: user.user!.uid).limit(1).get();

                            if (getData.docs.isEmpty) {
                              throw FirebaseAuthException(code: 'user-not-found');
                            }

                            AccountData data = AccountData(
                              email: user.user!.email,
                              username: getData.docs[0]['username'],
                              phone: getData.docs[0]['phone'],
                              uid: user.user!.uid,
                              dark: getData.docs[0]['dark'],
                            );

                            Provider.of<ProviderVariables>(context, listen: false).dark = getData.docs[0]['dark'];
                            Provider.of<ProviderVariables>(context, listen: false).data = data;
                            Navigator.pushReplacementNamed(context, 'HomeNavigationBar');
                          } on FirebaseAuthException catch (exc) {
                            if (exc.code == 'user-not-found') {
                              await FirebaseAuth.instance.currentUser!.delete();
                              showSnackBar(context, 'Email not found');
                            }
                          } catch (exc) {
                            showSnackBar(context, 'Error');
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        text: 'Sign-In with Google',
                        asset: 'assets/images/Google.svg.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> loginNormally(BuildContext context, String emailOrUsername, String password) async {
  try {
    String? email;
    String? username;
    String? uid;
    String? phone;
    bool dark = false;

    if (emailOrUsername.contains('@')) {
      email = emailOrUsername;
    } else {
      username = emailOrUsername;
    }

    if (email == null) {
      var data = await FirebaseFirestore.instance.collection(usernameCollection).where('username', isEqualTo: username).limit(1).get();
      data.docs.isEmpty ? throw FirebaseAuthException(code: 'username-not-found') : null;
      dark = data.docs[0].data()['dark'];
      phone = data.docs[0].data()['phone'];
      uid = data.docs[0].id;
      email = await GetAccountData.getEmailFromFirestore(data.docs[0].id);
      await SignIn.signIn(email!, password);
    } else if (username == null) {
      UserCredential user = await SignIn.signIn(email, password);
      username = await GetAccountData.getUsernameFromFirestore(user.user!.uid);
      var data = await FirebaseFirestore.instance.collection(usernameCollection).doc(user.user!.uid).get();
      uid = user.user!.uid;
      dark = data.data()!['dark'];
      phone = data.data()!['phone'];
    }

    AccountData data = AccountData(
      email: email,
      username: username,
      phone: phone,
      uid: uid,
      dark: dark,
    );

    Provider.of<ProviderVariables>(context, listen: false).dark = dark;
    Provider.of<ProviderVariables>(context, listen: false).data = data;
    Navigator.pushReplacementNamed(context, 'HomeNavigationBar');
  } on FirebaseAuthException catch (exc) {
    if (exc.code == 'user-not-found') {
      showSnackBar(context, 'Email not found');
    } else if (exc.code == 'username-not-found') {
      showSnackBar(context, 'Username not found');
    } else if (exc.code == 'wrong-password') {
      showSnackBar(context, 'Wrong password');
    } else if (exc.code == 'invalid-email') {
      showSnackBar(context, 'Invalid email');
    } else if (exc.code == 'network-request-failed') {
      showSnackBar(context, 'No internet');
    } else if (exc.code == 'too-many-requests') {
      showSnackBar(context, 'Too many attempts, Try again later');
    } else {
      showSnackBar(context, 'Error');
    }
  } catch (exc) {
    showSnackBar(context, 'Error');
  }
}
