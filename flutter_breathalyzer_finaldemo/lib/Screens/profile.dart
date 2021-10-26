import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String EC='';

  void profiledata()async {
    late DocumentSnapshot documentSnapshot;

    await FirebaseFirestore.instance.collection('users')
        .doc(firebaseUser!.uid)
        .get()
        .then((value) {
      documentSnapshot = value;
    });

    String name = documentSnapshot['Name'];
    String dob = documentSnapshot['Date of Birth'];
    String gender = documentSnapshot['Gender'];
    String ec = documentSnapshot['Emergency Contact'];
  }

  Future<void> updateUser() {
    return FirebaseFirestore.instance.collection('users')
        .doc(firebaseUser!.uid)
        .update({'Emergency Contact': EC})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

            );
          }
  }