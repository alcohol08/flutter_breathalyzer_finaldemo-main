import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordsScreen extends StatefulWidget {
  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
        centerTitle: true,
        backgroundColor: Color(0xFF398AE5),
      ),
      floatingActionButton: null,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser!.uid)
              .collection('BAC')
              .orderBy('Date & Time of Record', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){return Center(
              child: CircularProgressIndicator(),
            );
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Card(
                    child: SingleChildScrollView(
                        child: ListTile(
                          leading: Icon(
                            Icons.liquor,
                            size: 40.0,
                            color: data['Color'],
                          ),
                          title: Text(data['Condition'] +'\nBAC Level: '+data['BAC Level'],
                              style:TextStyle(
                                  height:2,
                                  color: Colors.black,
                                  fontSize:20,
                                  fontWeight: FontWeight.w500)
                          ),
                          subtitle:  Text('Time of Record: '+data['Date & Time of Record'] ,
                              style:TextStyle(
                                  height:3,
                                  fontSize:15)
                          ),
                        )
                    )
                );
              }).toList(),
            );
          }
      ),
    );
  }
}