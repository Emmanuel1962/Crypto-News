// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyptonews/Screens/home_screen.dart';
import 'package:cyptonews/Screens/sign_up.dart';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> authkey = GlobalKey<FormState>();

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool showpassword = false;
  // bool? isChecked = false;
  bool isLoading = false;
  String errorMsg = "";

  void login() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );

      var id = userCredential.user!.uid;
// this brings gets the data from the database
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();

      var userdetails = {
        'user_id': doc['user_id'],
        'Username': doc['Username'],
        'Email': doc['Email']
      };

      var route = MaterialPageRoute(
        builder: (context) => HomeScreen(user: userdetails),
      );
      Navigator.push(context, route);
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
      });
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void switchPassword() {
    showpassword = !showpassword;
    setState(() {});
  }

  // Image appLogo = const Image(
  //     image: ExactAssetImage("assets/images/IMG-20240304-WA0189.jpg"),
  //     height: 1200.0,
  //     width: 1200,
  //     alignment: FractionalOffset.center);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          // title: Image.asset(
          //   "assets/images/IMG-20240304-WA0189.jpg",
          //   fit: BoxFit.contain,
          //   height: 200,
          // ),
          // toolbarHeight: 250,
          // centerTitle: true,
          ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: size.height,
        width: size.width,
        child: Form(
          key: authkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/IMG-20240304-WA0189.jpg",
                  height: 200,
                  width: 200,
                ),
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    label: const Text('Email'),
                    hintText: " Enter your Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey,
                    prefixIcon: const Icon(Icons.mail),
                  ),
                  validator: (value) {
                    var emailVaild = EmailValidator.validate(value!);
                    if (!emailVaild) {
                      return "Invaild  Email Address";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordCtrl,
                  decoration: InputDecoration(
                    label: const Text('Password'),
                    hintText: " Enter your Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        switchPassword();
                      },
                      icon: showpassword
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please fill in Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                // rows are used to align two widgets on the same line
                MaterialButton(
                  onPressed: () {
                    if (authkey.currentState!.validate()) {
                      login();
                    }
                  },
                  color: Colors.green,
                  shape: const StadiumBorder(),
                  child: const Text("Sign in"),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Do not have an account?'),
                    TextButton(
                        onPressed: () {
                          var route = MaterialPageRoute(
                              builder: (context) => const SignUp());
                          Navigator.push(context, route);
                        },
                        child: const Text("Sign Up"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
