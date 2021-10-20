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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ListTile(
                      title: Text('Name: '+data['Name'],style:TextStyle(height:5,fontSize:20) ),
                    ),
                    ListTile(
                      title: Text('Date of Birth: '+data['Date of Birth'],style:TextStyle(height:5,fontSize:20) ),
                    ),
                    ListTile(
                      title: Text('Gender: '+data['Gender'],style:TextStyle(height:5,fontSize:20) ),
                    ),
                    ListTile(
                      title: Text('Emergency Contact: '+data['Emergency Contact'],style:TextStyle(height:5,fontSize:20) ),
                    ),
                  ],
                );
              }).toList(),
            );
          }
      ),
    );
  }
}