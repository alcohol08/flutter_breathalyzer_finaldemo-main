import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_breathalyzer/Component/button.dart';
import 'package:date_field/date_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseFirestore.instance;
  final userCollections = FirebaseFirestore.instance.collection("users");
  String email = '';
  String password = '';
  String name = '';
  String dob='';
  String dropdownValue = 'Enter your gender';
  var formatter = new DateFormat('dd-MM-yyyy');
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
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  padding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: '1',
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                                Icons.mail,
                                color: Color(0xFF398AE5)),
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(),
                            labelText: 'Enter your email'

                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value.toString().trim();
                        },
                        validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",


                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                                Icons.lock,
                                color: Color(0xFF398AE5)),
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(),
                            labelText: 'Enter your password'
                        ),
                              validator: (value) {
                              if (password.length < 8) {
                              return "Password must be at least 8 characters long";
                              }
                              },
                              onChanged: (value) {
                                password = value;
                              }),
                      SizedBox(height: 30),
                      TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                                Icons.account_circle,
                                color: Color(0xFF398AE5)),
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(),
                            labelText: 'Enter your name'
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                          onChanged: (value) {
                            name = value;
                          }),
                      SizedBox(height: 30),
                      DateTimeFormField(
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          labelText: 'Enter your birth date',
                          prefixIcon: Icon(
                              Icons.event_note,
                              color: Color(0xFF398AE5)),

                        ),
                        mode: DateTimeFieldPickerMode.date,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value == null ? 'Please enter your birth date' : null,
                        onDateSelected: (DateTime value) {
                          print(value);
                          dob = formatter.format(value);
                        },
                      ),
                      SizedBox(height: 30),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                              Icons.wc,
                              color: Color(0xFF398AE5)),
                        ),

                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16

                        ),

                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: <String>['Enter your gender','Male','Female']
                            .map<DropdownMenuItem<String>>((String value){
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                            .toList(),
                        validator: (value) {
                          if (value == 'Enter your gender') {
                            return 'Enter your gender';
                          }
                        },
                      ),
                      SizedBox(height: 50),
                      LoginSignupButton(
                        title: 'Register',
                        ontapp: () async {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });
                            try {
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password)
                                  .then((value) {
                                String userId = value.user!.uid;
                                if (userId !=null) {
                                  userCollections.doc(userId).set({'Name': name, 'Date of Birth': dob, 'Gender': dropdownValue, 'Emergency Contact':'NIL'});
                                }
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.blueGrey,
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Successfully Registered.You Can Login Now'),
                                  ),
                                  duration: Duration(seconds: 5),
                                ),
                              );
                              Navigator.of(context).pop();

                              setState(() {
                                isloading = false;
                              });
                            } on FirebaseAuthException catch (e) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title:
                                  Text(' Oops! Registration Failed'),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}