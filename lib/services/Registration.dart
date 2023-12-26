// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:panasonic/constants.dart';

class SignIn {
  static Future<UserCredential> signIn(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<UserCredential> signInWithUid(String uid) async {
    return await FirebaseAuth.instance.signInWithCredential(EmailAuthProvider.credential(email: '', password: ''));
  }
}

class GetAccountData {
  static Future<String?> getUsernameFromFirestore(String uid) async {
    var d = await FirebaseFirestore.instance.collection(usernameCollection).doc(uid).get();
    return d.data()!['username'];
  }

  static Future<String?> getEmailFromFirestore(String uid) async {
    var d = await FirebaseFirestore.instance.collection(usernameCollection).doc(uid).get();
    return d.data()!['email'];
  }

  static Future<String?> getPhoneNumberFromFirestore(String uid) async {
    var d = await FirebaseFirestore.instance.collection(usernameCollection).doc(uid).get();
    return d.data()!['phone'];
  }

  static Future<String?> getEmailFromFirebaseAuth(String uid) async {
    User? user = await FirebaseAuth.instance.userChanges().firstWhere((user) => user!.uid == uid);
    return user?.email;
  }

  static Future<String?> getUID(String username) async {
    QuerySnapshot uidDocument = await FirebaseFirestore.instance.collection(usernameCollection).where('username', isEqualTo: username).limit(1).get();
    return uidDocument.docs[0].id;
  }
}

class Register {
  static Future<UserCredential> register(String email, String username, String phone, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseFirestore.instance.collection(usernameCollection).doc(userCredential.user!.uid).set({'email': email, 'username': username, 'phone': phone, 'dark': false}, SetOptions(merge: true));
    return userCredential;
  }
}

class SignOut {
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> deleteAccount(String uid, String email) async {
    await FirebaseFirestore.instance.collection(usernameCollection).doc(uid).delete();
    await FirebaseFirestore.instance.collection(usersCollection).doc(email).delete();
    await FirebaseAuth.instance.currentUser!.delete();
  }
}

// zeyad06
// zeyad@gmail.com
// 06062003