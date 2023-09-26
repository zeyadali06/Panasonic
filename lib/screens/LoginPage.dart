// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:panasonic/services/SignInAndRegister.dart';
import 'package:panasonic/components/helper.dart';
import 'package:panasonic/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:panasonic/main.dart';
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
  GlobalKey<FormState> deviceKey = GlobalKey();
  GlobalKey<FormState> descriptionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: ListView(
            children: [
              // Animation
              const SizedBox(height: 20),
              Lottie.asset('assets/animated_images/animation_llz60pig.json'),
              SingleChildScrollView(
                padding: const EdgeInsets.all(KPadding),
                child: Column(
                  children: [
                    // Panasonic
                    const Center(child: Text('Panasonic', style: TextStyle(fontSize: 45, fontWeight: FontWeight.w900, color: KPrimayColor))),
                    const SizedBox(height: 50),

                    // Log In
                    const Row(children: [Center(child: Text('Log In', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: KPrimayColor)))]),
                    const SizedBox(height: 25),

                    // Email Or Username
                    Focus(
                      onFocusChange: (value) {
                        deviceKey.currentState!.validate();
                      },
                      child: Form(
                        key: deviceKey,
                        child: CustomTextFormField(
                          prefixIcon: Icons.email,
                          label: 'Email or Username',
                          hintText: 'Enter Your Email or Username',
                          onChanged: (data) {
                            deviceKey.currentState!.validate();
                            emailOrUsername = data;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Password
                    Focus(
                      onFocusChange: (value) {
                        descriptionKey.currentState!.validate();
                      },
                      child: Form(
                        key: descriptionKey,
                        child: CustomTextFormField(
                          prefixIcon: Icons.lock_outlined,
                          label: 'Password',
                          hintText: 'Enter Your Password',
                          obscureText: true,
                          onChanged: (data) {
                            descriptionKey.currentState!.validate();
                            password = data;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Login Button
                    CustomButton(
                      color: KPrimayColor,
                      borderColor: KPrimayColor,
                      widget: const Text('Login', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                      onTap: () async {
                        if (deviceKey.currentState!.validate() && descriptionKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          await loginNormally(context, emailOrUsername!, password!);
                          setState(() {
                            isLoading = false;
                          });
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
                          Provider.of<ProviderVariables>(context, listen: false).email = user.user!.email;
                          Navigator.pushReplacementNamed(context, 'HomeNavigationBar');
                        } catch (exc) {
                          showSnackBar(context, 'Error');
                        }
                        setState(() {
                          isLoading = true;
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
    );
  }
}

Future<void> loginNormally(BuildContext context, String emailOrUsername, String password) async {
  try {
    String? email;
    String? username;

    if (emailOrUsername.contains('@')) {
      email = emailOrUsername;
    } else {
      username = emailOrUsername;
    }

    if (email == null) {
      var uidDocument = await FirebaseFirestore.instance.collection(usernameCollection).where('username', isEqualTo: username).limit(1).get();
      email = await SignIn.getEmailFromFirestore(uidDocument.docs[0].id);
      await SignIn.signIn(email!, password);
    } else if (username == null) {
      UserCredential user = await SignIn.signIn(email, password);
      username = await SignIn.getUsernameFromFirestore(user.user!.uid);
    }

    Provider.of<ProviderVariables>(context, listen: false).email = email;
    Provider.of<ProviderVariables>(context, listen: false).username = username;

    Navigator.pushReplacementNamed(context, 'HomeNavigationBar');
  } on FirebaseAuthException catch (exc) {
    if (exc.code == 'user-not-found') {
      showSnackBar(context, 'Email not found');
    } else if (exc.code == 'wrong-password') {
      showSnackBar(context, 'Wrong Email or Password');
    } else if (exc.code == 'invalid-email') {
      showSnackBar(context, 'Invalid Email');
    } else if (exc.code == 'network-request-failed') {
      showSnackBar(context, 'No Internet');
    } else {
      showSnackBar(context, 'Error');
    }
  } catch (exc) {
    print(exc);
    showSnackBar(context, 'Error');
  }
}

// zeyad@gmail.com

// 06062003