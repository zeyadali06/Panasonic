// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:panasonic/components/helper.dart';
import 'package:panasonic/models/AccountDataModel.dart';
import 'package:panasonic/services/Registration.dart';
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

                      // Register
                      const Row(children: [Center(child: Text('Register', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: KPrimayColor)))]),
                      const SizedBox(height: 25),

                      // Username
                      CustomTextFormField(
                        prefixIcon: Icons.person,
                        label: 'Username',
                        hintText: 'Enter Your Username',
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]"))],
                        onChanged: (data) {},
                        onSaved: (value) {
                          username = value!.trim();
                        },
                      ),
                      const SizedBox(height: 10),

                      // Email
                      CustomTextFormField(
                        prefixIcon: Icons.email,
                        label: 'Email',
                        hintText: 'Enter Your Email',
                        onChanged: (data) {},
                        onSaved: (value) {
                          email = value!.trim();
                        },
                      ),
                      const SizedBox(height: 10),

                      // Phone
                      CustomTextFormField(
                        prefixIcon: Icons.phone,
                        label: 'Phone',
                        hintText: 'Enter Your Phone Number',
                        onChanged: (data) {},
                        onSaved: (value) {
                          phone = value!.trim();
                        },
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
                          password = value!.trim();
                        },
                      ),
                      const SizedBox(height: 10),

                      // Confirm Password
                      CustomTextFormField(
                        prefixIcon: Icons.lock_outlined,
                        label: 'Confirm Password',
                        hintText: 'Confirm Your Password',
                        obscureText: true,
                        onChanged: (data) {},
                        onSaved: (value) {
                          confirmPassword = value!.trim();
                        },
                      ),
                      const SizedBox(height: 30),

                      // Register Button
                      CustomButton(
                        color: KPrimayColor,
                        borderColor: KPrimayColor,
                        widget: const Text('Register', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await registerNormally(context, email, username, phone, password, confirmPassword);
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            mode = AutovalidateMode.always;
                            setState(() {});
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

                            var usernameChecker = await FirebaseFirestore.instance.collection(usernameCollection).where('email', isEqualTo: user.user!.email).limit(1).get();
                            if (usernameChecker.docs.isNotEmpty) {
                              await SignOut.signOut();
                              setState(() {
                                isLoading = false;
                              });
                              throw FirebaseAuthException(code: 'email-already-in-use');
                            }
                            AccountData data = AccountData(email: user.user!.email, uid: user.user!.uid, dark: false);
                            Provider.of<ProviderVariables>(context, listen: false).dark = false;
                            Provider.of<ProviderVariables>(context, listen: false).data = data;
                            Navigator.pushNamed(context, 'CompleteRegisterPage');
                          } on FirebaseAuthException catch (exc) {
                            if (exc.code == 'email-already-in-use') {
                              showSnackBar(context, 'Email already exist');
                            }
                          } catch (_) {
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

Future<void> registerNormally(BuildContext context, String email, String username, String phone, String password, String confirmPassword) async {
  try {
    var usernameChecker = await FirebaseFirestore.instance.collection(usernameCollection).where('username', isEqualTo: username).limit(1).get();
    usernameChecker.docs.isNotEmpty ? throw FirebaseAuthException(code: 'username-already-in-use') : null;
    password != confirmPassword ? throw FirebaseAuthException(code: 'wrong-confirmation') : null;

    AccountData data = AccountData(
      email: email,
      username: username,
      phone: phone,
      dark: false,
    );

    UserCredential user = await Register.register(data.toMap(), password);
    data.uid = user.user!.uid;

    Provider.of<ProviderVariables>(context, listen: false).data = data;
    Provider.of<ProviderVariables>(context, listen: false).dark = false;
    Navigator.pushReplacementNamed(context, 'HomeNavigationBar');
  } on FirebaseAuthException catch (exc) {
    if (exc.code == 'weak-password') {
      showSnackBar(context, 'Weak password');
    } else if (exc.code == 'email-already-in-use') {
      showSnackBar(context, 'Email already exist');
    } else if (exc.code == 'username-already-in-use') {
      showSnackBar(context, 'Username already exist');
    } else if (exc.code == 'wrong-confirmation') {
      showSnackBar(context, "Password and it's confirmation dosen't same");
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
