import 'package:flutter/material.dart';
import '../constant.dart';
import 'package:flutter_breathalyzer/Component/button.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ForgotPasswordScreen extends StatefulWidget{
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseFirestore.instance;
  final userCollections = FirebaseFirestore.instance.collection("users");
  String email = '';
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,size: 30,),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isloading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Form(
          key: formkey,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(
              children: [
                Container(
                  height: double. infinity,
                  width:double. infinity,
                  color: Colors.grey[200],
                  child: SingleChildScrollView(
                    padding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: '1',
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value.toString().trim();
                          },
                          validator: (value) => (value!.isEmpty)
                              ? ' Please enter email'
                              : null,
                          textAlign: TextAlign.center,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText:  'Enter Your Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        LoginSignupButton(
                          title: 'Reset',
                          ontapp: () async {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                isloading = true;
                              });
                              try {
                                await _auth.sendPasswordResetEmail(
                                    email: email);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.grey,
                                      content: Text(
                                        'Password Reset Email has been sent',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      duration: Duration(seconds: 5),
                                    ),
                                );

                                setState(() {
                                  isloading = false;
                                });
                              } on FirebaseAuthException catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Ops! Email not registered"),
                                    content: Text('${e.message}'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text('Okay'),
                                      )
                                    ],
                                  ),
                                );
                                print(e);
                              }
                              setState(() {
                                isloading = false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
    );
  }
}