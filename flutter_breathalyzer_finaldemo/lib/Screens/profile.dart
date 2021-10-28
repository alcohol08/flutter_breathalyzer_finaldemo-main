//@dart=2.9
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../Components/profile_widget.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../Screens/editprofile.dart';
import '../Screens/home.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String name = '';
  String dob = '';
  String ec = '';
  String gender = '';
  String fp = '';


  void _getdata1() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        name = userData.data()['Name'];
        dob = userData.data()['Date of Birth'];
        ec = userData.data()['Emergency Contact'];
        gender = userData.data()['Gender'];
        fp = userData.data()['Image Path'];
      }
      );
    }
    );
  }
  Future<void> updateUser() {
    return FirebaseFirestore.instance.collection('users')
        .doc(firebaseUser.uid)
        .update({'Image Path': fp})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  @override
  void initState() {
    super.initState();
    _getdata1();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
        leading: BackButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          ProfileWidget(
            imagePath: fp,
            isEdit: true,
            onClicked: () async {
              final image = await ImagePicker()
                  .getImage(source: ImageSource.gallery);

              if (image == null) return;

              final directory = await getApplicationDocumentsDirectory();
              final name = basename(image.path);
              final imageFile = File('${directory.path}/$name');
              final newImage =
              await File(image.path).copy(imageFile.path);
              fp = newImage.path;
              updateUser();
              setState(() {
              });

            },
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                "${firebaseUser.email}",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          const SizedBox(height: 48),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date of Birth',
                  style: TextStyle(fontSize: 14, fontFamily:'Open Sans', color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  dob,
                  style: TextStyle(fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1.5,
            indent: 48,
            endIndent: 48
          ),

          const SizedBox(height: 25),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gender',
                  style: TextStyle(fontSize: 14, fontFamily:'Open Sans', color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  gender,
                  style: TextStyle(fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
          const Divider(
              height: 20,
              thickness: 1.5,
              indent: 48,
              endIndent: 48
          ),
          const SizedBox(height: 25),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Contact',
                  style: TextStyle(
                      fontSize: 14, fontFamily:'Open Sans', color: Colors.grey, height: 1.5),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  iconSize: 12,
                  splashRadius: 1,
                  alignment: Alignment.topLeft,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen()));
                  },
                )
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ec,
                  style: TextStyle(fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
          const Divider(
              height: 20,
              thickness: 1.5,
              indent: 48,
              endIndent: 48
          ),
        ],
      ),
    );
  }
}