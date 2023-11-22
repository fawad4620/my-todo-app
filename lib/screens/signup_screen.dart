import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Your Account"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15))),
              ),
              SizedBox(height: 15),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15))),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15))),
              ),
              SizedBox(height: 15),
              TextField(
                controller: confirmController,
                decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15))),
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () async {
                      var fullName = fullNameController.text.trim();
                      var email = emailController.text.trim();
                      var password = passwordController.text.trim();
                      var confirm = confirmController.text.trim();
                      if (fullName.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty ||
                          confirm.isEmpty) {
                        Fluttertoast.showToast(msg: "Please fill all field");
                        return;
                      }
                      if (password.length < 6) {
                        Fluttertoast.showToast(msg: "Week password");
                        return;
                      }
                      if (password != confirm) {
                        Fluttertoast.showToast(msg: "Password do not match");
                        return;
                        // show text
                      }
                      ProgressDialog progressDialog = ProgressDialog(context,
                          title: Text("Signing Up"),
                          message: Text("Please wait"));
                      progressDialog.show();
                      try {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        UserCredential userCredential =
                            await auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (userCredential.user != null) {
                          DatabaseReference userRef = FirebaseDatabase.instance
                              .reference()
                              .child("users");
                          String uid = userCredential.user!.uid;
                          int dt = DateTime.now().microsecondsSinceEpoch;
                          await userRef.child(uid).set({
                            "FullName": fullName,
                            "Email": email,
                            "uId": uid,
                            "dt": dt,
                          });
                          Fluttertoast.showToast(msg: 'Success');
                          Navigator.of(context).pop();
                        } else {
                          Fluttertoast.showToast(msg: 'Failed');
                        }
                        progressDialog.dismiss();
                      } on FirebaseAuthException catch (e) {
                        progressDialog.dismiss();
                        Fluttertoast.showToast(msg: e.message.toString());
                      } catch (e) {
                        progressDialog.dismiss();
                        Fluttertoast.showToast(msg: "Something went wrong");
                      }
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
