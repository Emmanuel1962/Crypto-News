// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyptonews/Screens/home_screen.dart';
import 'package:cyptonews/Screens/sign_in.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> authkey = GlobalKey<FormState>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool showpassword = false;
  // bool? isChecked = false;
  bool isLoading = false;
  String errorMsg = "";
  void register() async {
    setState(() {
      isLoading = true;
    });
    try {
      // this is where the id is coming from
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
      // this is where the id is coming from
      var id = userCredential.user!.uid;
      // first you create your class(thats what you want to save in your firebase)
      var userDetails = {
        'user_id': id,
        'Username': usernameCtrl.text,
        'Email': emailCtrl.text,
        'Password': passwordCtrl.text,
      };
// this creates/set the collection in the firebase and stores the data in it
      FirebaseFirestore.instance.collection('users').doc(id).set(userDetails);

      var route = MaterialPageRoute(
        builder: (context) => HomeScreen(user: userDetails),
      );
      Navigator.push(context, route);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void switchPassword() {
    showpassword = !showpassword;
    setState(() {});
  }

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
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                    label: const Text('Username'),
                    hintText: " Enter your Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please fill in Username";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
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
                MaterialButton(
                  onPressed: () {
                    if (authkey.currentState!.validate()) {
                      register();
                    }
                  },
                  color: Colors.green,
                  shape: const StadiumBorder(),
                  child: const Text('Sign Up'),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Rows are used to align two widget on the same line
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                        onPressed: () {
                          var route = MaterialPageRoute(
                              builder: (context) => const SignIn());
                          Navigator.push(context, route);
                        },
                        child: const Text("Sign In"))
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
