import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_breathalyzer/Components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screens/profile.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final formkey = GlobalKey<FormState>();
  final userCollections = FirebaseFirestore.instance.collection("users");
  String ec = '';
  bool isloading = false;

  final TextEditingController controller = TextEditingController();

  Future<void> updateUser() {
    return FirebaseFirestore.instance.collection('users')
        .doc(firebaseUser!.uid)
        .update({'Emergency Contact': ec})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Emergency Contact'),
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: isloading
          ? Center(
            child: CircularProgressIndicator(),)
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
                          SizedBox(height: 30),
                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              //print(number.phoneNumber);
                              setState((){ec = number.toString();});
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(color: Colors.black),
                            initialValue: PhoneNumber(isoCode: 'SG'),
                            textFieldController: controller,
                            formatInput: false,
                            keyboardType:
                            TextInputType.numberWithOptions(signed: true, decimal: true),
                            inputBorder: OutlineInputBorder(),
                            onSaved: (PhoneNumber number) {
                              print('On Saved: $number');
                              //ed = number;
                            },
                          ),
                          SizedBox(height: 30),
                          LoginSignupButton(
                            title: 'Edit',
                            ontapp: () {
                              updateUser();
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ProfileScreen()));
                            }
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