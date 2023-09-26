import 'package:flutter/material.dart';
import 'package:panasonic/constants.dart';
import 'package:panasonic/screens/LoginPage.dart';

class MyAccountPage extends StatefulWidget {
  final Function refresh;

  const MyAccountPage({super.key, required this.refresh});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  void performAction() {
    widget.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Account"),
        centerTitle: true,
        backgroundColor: KPrimayColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 70,
                    // backgroundImage: AssetImage("assets/images/profile-user.png"),
                    backgroundColor: Colors.white,
                  ),
                  Positioned(
                    bottom: 3,
                    right: 5,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.deepPurple[100]),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        color: Colors.indigo[600],
                        iconSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text('username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black)),
            const SizedBox(height: 6),
            const Text('email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
            const SizedBox(height: 25),
            Expanded(
              child: ListTile(
                title: const Text("Settings", style: TextStyle(fontSize: 20, color: Colors.black)),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: KPrimayColor),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: KPrimayColor,
                  ),
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
            Expanded(
              child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: KPrimayColor),
                    child: const Icon(
                      Icons.language_outlined,
                      color: KPrimayColor,
                    ),
                  ),
                  title: Text("Language", style: TextStyle(fontSize: 20, color: Colors.black)),
                  trailing: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.black),
                  )),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: KPrimayColor),
                  child: const Icon(Icons.color_lens_outlined, color: KPrimayColor),
                ),
                title: Text("Theme", style: TextStyle(fontSize: 20, color: Colors.black)),
                trailing: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  // child: Switch(
                  //   inactiveThumbImage: const AssetImage("assets/images/sun.png"),
                  //   inactiveTrackColor: Colors.orange[200],
                  //   activeTrackColor: Colors.blueGrey[900],
                  //   activeThumbImage: const AssetImage("assets/images/darkMode.png"),
                  //   value: Global.dark,
                  //   onChanged: (value) async {
                  //     // setState(() {
                  //     //   Global.dark = !Global.dark;
                  //     //   performAction();
                  //     // });
                  //     // SharedPreferences prefs = await SharedPreferences.getInstance();
                  //     // prefs.setBool("dark", Global.dark);
                  //   },
                  // ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 140,
              child: ElevatedButton(
                onPressed: () async {
                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                  // prefs.setBool('rememberMe', false);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: KPrimayColor, side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                child: const Text("Logout", style: TextStyle(color: KPrimayColor)),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}



// zeyad@gmail.com

// 06062003


// zeyadali6060@gmail.com

// Ze06062003#


// set@gmail.com

// set.com