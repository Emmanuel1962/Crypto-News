// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyptonews/Screens/home_screen.dart';
import 'package:cyptonews/Screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 5), () async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        var route = MaterialPageRoute(builder: (context) => const SignIn());
        Navigator.push(context, route);
      } else {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        var userDetails = {
          'user_id': doc['user_id'],
          'Username': doc['Username'],
          'Email': doc["Email"]
        };
        var route = MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(user: userDetails));
        Navigator.push(context, route);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        // color: Colors.blueGrey,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: size.height / 2,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                image: const DecorationImage(
                  image: AssetImage("assets/images/IMG-20240304-WA0189.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Text('Cyrpto News At your Door Step '),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}
