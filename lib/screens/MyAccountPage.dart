// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:panasonic/constants.dart';
import 'package:panasonic/main.dart';
import 'package:provider/provider.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key, required this.refresh});

  final Function refresh;

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool loading = false;

  void performAction() {
    widget.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: KPrimayColor,
        title: const Text("My Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Photo
            Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage("assets/images/profile-user.png"),
                      backgroundColor: Colors.grey,
                    ),
                    Positioned(
                      bottom: 3,
                      right: 5,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: KPrimayColor),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          color: Colors.white,
                          iconSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),

                // Username
                Text('${Provider.of<ProviderVariables>(context, listen: false).username}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black)),
                const SizedBox(height: 6),

                // Email
                Text('${Provider.of<ProviderVariables>(context).email}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                const SizedBox(height: 25),
              ],
            ),

            Column(
              children: [
                // Settings
                GestureDetector(
                  onTap: () {},
                  child: ListTile(
                    title: const Text("Settings", style: TextStyle(fontSize: 20, color: Colors.black)),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: KPrimayColor),
                      child: const Icon(Icons.settings_outlined, color: Colors.white),
                    ),
                    trailing: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Language
                GestureDetector(
                  onTap: () {},
                  child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: KPrimayColor),
                        child: const Icon(Icons.language_outlined, color: Colors.white),
                      ),
                      title: const Text("Language", style: TextStyle(fontSize: 20, color: Colors.black)),
                      trailing: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                      )),
                ),
                const SizedBox(height: 10),

                // Theme
                GestureDetector(
                  onTap: () {},
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: KPrimayColor),
                      child: const Icon(Icons.color_lens_outlined, color: Colors.white),
                    ),
                    title: const Text("Theme", style: TextStyle(fontSize: 20, color: Colors.black)),
                    trailing: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                      child: Switch(
                        inactiveThumbImage: const AssetImage("assets/images/sun.png"),
                        inactiveTrackColor: Colors.orange[200],
                        activeTrackColor: Colors.blueGrey[900],
                        activeThumbImage: const AssetImage("assets/images/darkMode.png"),
                        value: false,
                        onChanged: (value) async {
                          // setState(() {
                          //   Global.dark = !Global.dark;
                          //   performAction();
                          // });
                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                          // prefs.setBool("dark", Global.dark);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Logout Button
            MaterialButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await FirebaseAuth.instance.signOut();
                Provider.of<ProviderVariables>(context, listen: false).category = null;
                Provider.of<ProviderVariables>(context, listen: false).compatibility = null;
                Provider.of<ProviderVariables>(context, listen: false).email = null;
                Provider.of<ProviderVariables>(context, listen: false).product = null;
                Provider.of<ProviderVariables>(context, listen: false).used = null;
                Provider.of<ProviderVariables>(context, listen: false).username = null;
                Navigator.pushReplacementNamed(context, 'LoginPage');
              },
              height: 50,
              minWidth: 140,
              shape: RoundedRectangleBorder(borderRadius: KRadius, side: const BorderSide(color: KPrimayColor)),
              color: KPrimayColor,
              child: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}


// zeyad06
// zeyad@gmail.com
// 06062003


// zeyadali6060@gmail.com

// Ze06062003#


// set@gmail.com

// set.com