import 'package:flutter/material.dart';
import 'package:ai_assistant/commons.dart';
import 'package:ai_assistant/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_assistant/models/user_data.dart' as model;

class AuthController {
  void loginUser(String username, String password, BuildContext context) async {
    try {
      if (username.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await firebaseAuth.signInWithEmailAndPassword(
          email: username,
          password: password,
        );
        userId = cred.user!.uid;
        showSnackBar(
            context, 'Login Successful. Redirecting to Home Screen...', 2);
        Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          ),
        );
      } else {
        showSnackBar(
            context, 'Error Logging in Please enter all the details', 2);
      }
    } catch (e) {
      showSnackBar(context, 'Error Logging in ${e.toString()}', 2);
    }
  }

  void createUser(String username, String password, String name,
      BuildContext context) async {
    try {
      if (username.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: username,
          password: password,
        );
        model.UserData userData = model.UserData(
          chats: {},
          name: name,
          username: username,
          uid: cred.user!.uid,
        );
        await firestore
            .collection('user_data')
            .doc(cred.user!.uid)
            .set(userData.toJson());
        userId = cred.user!.uid;
        showSnackBar(
            context, 'Sign Up Successful. Redirecting to Home Screen...', 2);
        Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          ),
        );
      } else {
        showSnackBar(
            context, 'Error Creating Account: Please enter all the details', 2);
      }
    } catch (e) {
      showSnackBar(
          context, 'Error Creating Account: Error: ${e.toString()}', 2);
    }
  }
}
