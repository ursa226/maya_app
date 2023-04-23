import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maya_app/auth.dart';
import 'package:maya_app/dashboard.dart' show MyDash;
import 'package:maya_app/signup.dart' show MySign;
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title(){
    return const Text('Firebase Auth');
  }
  Widget _userUid(){
    return Text(user?.email ?? 'User Email');
  }
  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: _title(),
    ),
    body: Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _userUid(),
          _signOutButton(),
        ],
      ),
    ),
  );
  }
}