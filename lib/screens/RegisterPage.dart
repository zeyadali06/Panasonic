// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:panasonic/components/helper.dart';
import 'package:panasonic/services/SignInAndRegister.dart';
import 'package:panasonic/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:panasonic/main.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String username;
  late String email;
  late String phone;
  late String password;
  late String confirmPassword;
  bool isLoading = false;

  GlobalKey<FormState> usernameKey = GlobalKey();
  GlobalKey<FormState> emailKey = GlobalKey();
  GlobalKey<FormState> phoneKey = GlobalKey();
  GlobalKey<FormState> passwordKey = GlobalKey();
  GlobalKey<FormState> confirmPasswordKey = GlobalKey();

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
                padding: const EdgeInsets.all(KHorizontalPadding),
                child: Column(
                  children: [
                    // Panasonic
                    const Center(child: Text('Panasonic', style: TextStyle(fontSize: 45, fontWeight: FontWeight.w900, color: KPrimayColor))),
                    const SizedBox(height: 50),

                    // Register
                    const Row(children: [Center(child: Text('Register', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: KPrimayColor)))]),
                    const SizedBox(height: 25),

                    // Username
                    Focus(
                      onFocusChange: (value) {
                        usernameKey.currentState!.validate();
                      },
                      child: Form(
                        key: usernameKey,
                        child: CustomTextFormField(
                          prefixIcon: Icons.person,
                          label: 'Username',
                          hintText: 'Enter Your Username',
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]"))],
                          onChanged: (data) {
                            usernameKey.currentState!.validate();
                            username = data.trim();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Email
                    Focus(
                      onFocusChange: (value) {
                        emailKey.currentState!.validate();
                      },
                      child: Form(
                        key: emailKey,
                        child: CustomTextFormField(
                          prefixIcon: Icons.email,
                          label: 'Email',
                          hintText: 'Enter Your Email',
                          onChanged: (data) {
                            emailKey.currentState!.validate();
                            email = data.trim();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Phone
                    Focus(
                      onFocusChange: (value) {
                        phoneKey.currentState!.validate();
                      },
                      child: Form(
                        key: phoneKey,
                        child: CustomTextFormField(
                          prefixIcon: Icons.phone,
                          label: 'Phone',
                          hintText: 'Enter Your Phone Number',
                          onChanged: (data) {
                            phoneKey.currentState!.validate();
                            phone = data.trim();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Password
                    Focus(
                      onFocusChange: (value) {
                        passwordKey.currentState!.validate();
                      },
                      child: Form(
                        key: passwordKey,
                        child: CustomTextFormField(
                          prefixIcon: Icons.lock_outlined,
                          label: 'Password',
                          hintText: 'Enter Your Password',
                          obscureText: true,
                          onChanged: (data) {
                            passwordKey.currentState!.validate();
                            password = data.trim();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Confirm Password
                    Focus(
                      onFocusChange: (value) {
                        confirmPasswordKey.currentState!.validate();
                      },
                      child: Form(
                        key: confirmPasswordKey,
                        child: CustomTextFormField(
                          prefixIcon: Icons.lock_outlined,
                          label: 'Confirm Password',
                          hintText: 'Confirm Your Password',
                          obscureText: true,
                          onChanged: (data) {
                            confirmPasswordKey.currentState!.validate();
                            confirmPassword = data.trim();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Register Button
                    CustomButton(
                      color: KPrimayColor,
                      borderColor: KPrimayColor,
                      widget: const Text('Register', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                      onTap: () async {
                        if (usernameKey.currentState!.validate() &&
                            emailKey.currentState!.validate() &&
                            phoneKey.currentState!.validate() &&
                            passwordKey.currentState!.validate() &&
                            confirmPasswordKey.currentState!.validate()) {
                          if (password != confirmPassword) {
                            showSnackBar(context, "Password and it's confirmation doesn't same");
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          await registerNormally(context, email, username, phone, password);
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),

                    // Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, 'LoginPage');
                            },
                            child: const Text('Login!', style: TextStyle(fontStyle: FontStyle.italic, color: KPrimayColor, fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const SizedBox(height: 20),

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
    );
  }
}

Future<void> registerNormally(BuildContext context, String email, String username, String phone, String password) async {
  try {
    var usernameChecker = await FirebaseFirestore.instance.collection(usernameCollection).where('username', isEqualTo: username).limit(1).get();
    if (usernameChecker.docs.isNotEmpty) {
      showSnackBar(context, 'Username Already Exist');
      return;
    }

    await Register.register(email, username, phone, password);
    Provider.of<ProviderVariables>(context, listen: false).email = email;
    Provider.of<ProviderVariables>(context, listen: false).username = username;
    Navigator.pushReplacementNamed(context, 'HomeNavigationBar');
  } on FirebaseAuthException catch (exc) {
    if (exc.code == 'weak-password') {
      showSnackBar(context, 'Weak password');
    } else if (exc.code == 'email-already-in-use') {
      showSnackBar(context, 'Email already exist');
    } else if (exc.code == 'invalid-email') {
      showSnackBar(context, 'Invalid Email');
    } else if (exc.code == 'network-request-failed') {
      showSnackBar(context, 'No Internet');
    } else {
      showSnackBar(context, 'Error');
    }
  } catch (exc) {
    showSnackBar(context, 'Error');
  }
}


// zeyad06
// zeyad@gmail.com
// 06062003
