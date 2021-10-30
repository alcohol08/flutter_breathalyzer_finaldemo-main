//@dart=2.9
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_breathalyzer/Screens/login.dart';
import 'package:flutter_breathalyzer/Screens/profile.dart';
import 'package:flutter_breathalyzer/Screens/records.dart';
import 'package:flutter_breathalyzer/Screens/donateus.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_breathalyzer/Screens/learn_list_screen.dart';
import 'package:flutter_breathalyzer/Screens/location.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  BluetoothConnection connection;
  BluetoothDevice mydevice;
  String op = "Press ConnectBT Button";
  Color status;
  bool isConnectButtonEnabled = true;
  bool isDisConnectButtonEnabled = false;
  double bac;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String name = '';
  String ec = '';
  String fp='';
  double tts;
  String tts1 = '';
  TwilioFlutter twilioFlutter;
  String Address = '';


  void _getdata() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        name = userData.data()['Name'];
        ec = userData.data()['Emergency Contact'];
        fp = userData.data()['Image Path'];
      }
      );
    }
    );
  }

  @override

  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC8e93842b5d219b06e3f3d8858ef27649',
        authToken: '4fc8ee4e7316a3d0d7564ee668ff5f2a',
        twilioNumber: '+13349663018');
    super.initState();
    _getdata();
  }

  void _connect() async {
    List<BluetoothDevice> devices = [];
    setState(() {
      isConnectButtonEnabled = false;
      isDisConnectButtonEnabled = true;
    });
    devices = await _bluetooth.getBondedDevices();
    // ignore: unnecessary_statements
    devices.forEach((device) {
      print(device);
      if (device.name == "HC-05") {
        mydevice = device;
        op = 'Connected. Awaiting reading...';
        tts1 = '';
      }
    });

    await BluetoothConnection.toAddress(mydevice?.address)
        .then((_connection) {
      print('Connected to the device' + mydevice.toString());

      connection = _connection;
    });

    connection.input.listen((Uint8List data) {
      print('Arduino Data : ${ascii.decode(data)}');
      setState(() async {
        bac = double.parse(ascii.decode(data));
        tts = bac * 3750;
        int h = tts ~/ 60;
        int m = (tts - 60 * h).round();
        tts1 =
            'Time to sobriety: ' + h.toString() + ' h ' + m.toString() + ' m';
        if (bac >= 0.08) {
          op = "Drunk\nBAC: 0" + ascii.decode(data);
          status = Colors.red;
          Position position = await _getGeoLocationPosition();
          GetAddressFromLatLong(position);
          sendSms();
        }
        else if (bac > 0 && bac < 0.08) {
          op = "Within limit\nBAC: 0" + ascii.decode(data);
          status = Colors.amber;
        }
        else {
          op = "Sober\nBAC: 0" + ascii.decode(data);
          status = Colors.green;
        }
      }
      );
      var now = new DateTime.now();
      var formatter = new DateFormat('dd-MM-yyyy – HH:mm');
      final String formattedDate = formatter.format(now);
      FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid)
          .collection('BAC').doc()
          .
      set({
        'Date & Time of Record': formattedDate,
        'BAC Level': bac,
        'Condition': op
      });
      FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid)
          .collection('BAC').doc()
          .
      set({'Date & Time of Record': formattedDate, 'Condition': op});
    }
    );

    connection.input.listen(null).onDone(() {
      print('Disconnected remotely!');
    }
    );
  }

  void _disconnect() {
    setState(() {
      op = "Disconnected";
      isConnectButtonEnabled = true;
      isDisConnectButtonEnabled = false;
    }
    );
    connection.close();
    connection.dispose();
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(()  {
    });
  }

  void sendSms() async {
    twilioFlutter.sendSMS(
        toNumber: ec,
        messageBody: 'Hi, your friend is drunk. Please come and get him at '+ Address + '.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("How to get started"),
                content: new Text(
                    '1. Switch on the DrinkÉ device.' +'\n\n' + '2. Connect to it.' + '\n\n' + '3. Press the warm up button.' + '\n\n'+ '4. Start blowing for 10 sec!'
                    , maxLines: 200),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        label: const Text('Help'),
      ),
      appBar: AppBar(
        title: Text('Drinké Breathalyser'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
        ],
      ),
      drawer: Drawer(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text("${firebaseUser.email}"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: FileImage(File(fp)),
                backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              title: new Text("User Profile"),
              leading: new Icon(Icons.account_circle_rounded),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              title: new Text("Records"),
              leading: new Icon(Icons.view_list_rounded),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RecordsScreen()));
              },
            ),
            ListTile(
              title: new Text("Learn"),
              leading: new Icon(Icons.account_circle_rounded),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LearnListScreen()));
              },
            ),
            ListTile(
              title: new Text("Location"),
              leading: new Icon(Icons.location_on_sharp),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LocationScreen()));
              },
            ),
            ListTile(
              title: new Text("Donate Us"),
              leading: new Icon(Icons.volunteer_activism_rounded),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DonateUs()));
              },
            ),
            Divider(
              height: 0.1,
            ),
            ListTile(
              title: new Text("Logout"),
              leading: new Icon(Icons.logout),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(padding: EdgeInsets.fromLTRB(60, 100, 0, 0),
                  child: FlatButton(
                    onPressed: isConnectButtonEnabled ? _connect : null,
                    child: Text("Connect BT"),
                    color: Colors.greenAccent,
                    disabledColor: Colors.grey,)
                  ,),
                SizedBox(width: 40,),
                Container(padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: FlatButton(
                    onPressed: isDisConnectButtonEnabled ? _disconnect : null,
                    child: Text("Disconnect BT"),
                    color: Colors.redAccent,
                    disabledColor: Colors.grey,)
                  ,),
              ],
            ),
          ),
          SizedBox(height: 200),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(color: Colors.white,
                  elevation: 100,
                  shadowColor: Colors.black,
                  child: Text(op, style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: status),),
                ),
                Card(color: Colors.white,
                  elevation: 100,
                  shadowColor: Colors.black,
                  child: Text(tts1, style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}