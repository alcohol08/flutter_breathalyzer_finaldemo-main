//@dart=2.9
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_breathalyzer/Screens/login.dart';
import 'package:flutter_breathalyzer/Screens/profile.dart';
import 'package:flutter_breathalyzer/Screens/records.dart';
import 'package:flutter_breathalyzer/Screens/donateus.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_breathalyzer/Screens/learn_list_screen.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  BluetoothConnection connection;
  BluetoothDevice mydevice;
  String op = '';
  bool isConnectButtonEnabled = true;
  bool isDisConnectButtonEnabled = false;
  bool showResults=false;
  double bac;
  String baclevel;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String name = '';
  String ec = '';
  String fp = '';
  double tts;
  int store;
  String centreText = 'Welcome Back';
  String tts1 = 'How long does it take to reach sobriety?';
  TwilioFlutter twilioFlutter;
  String Address = '';
  String _messageBuffer = '';
  String dataString = '';
  String warmcentreText = '';
  String blowcentreText = '';

  AnimationController _animationController;
  Animation tween;
  Color myColor = Colors.blue;
  String drinkingstatus = 'What is my drinking status?';

  List<_Message> messages = List<_Message>.empty(growable: true);

  RegExp exp = RegExp(r'(\w+)');
  RegExp checksec = RegExp(r'^[0-9]+\ss$');
  RegExp checksec2 = RegExp(r'^[0-9]+\sss$');
  RegExp re_bac = RegExp(r'^([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?$');
  var matchedText;
  var matchedText2;
  Iterable<Match> matches;
  Iterable<Match> matches2;

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC8e93842b5d219b06e3f3d8858ef27649',
        authToken: '74585ae96f011bbfed4e87b4981b3e9e',
        twilioNumber: '+13349663018');
    super.initState();
    _getdata();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    _animationController.addListener((){setState((){});});
  }


  //Firebase Cloud
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
      });
    });
  }

  void sendSms() async {
    Position position = await _getGeoLocationPosition();
    await GetAddressFromLatLong(position);
    twilioFlutter.sendSMS(
        toNumber: ec,
        messageBody: 'Hi, ' + name + ' is drunk. Please come and get him/her at ' + Address + '.');
  }

  //Location
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

  void _connect() async {
    List<BluetoothDevice> devices = [];
    setState(() {
      isConnectButtonEnabled = false;
      isDisConnectButtonEnabled = true;
    });
    Fluttertoast.showToast(
      msg: 'Pairing',
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16,
    );
    devices = await _bluetooth.getBondedDevices();
    // ignore: unnecessary_statements
    devices.forEach((device) {
      print(device);
      if (device.name == "HC-05") {
        mydevice = device;
        Fluttertoast.showToast(
          msg: 'Connected',
          backgroundColor: Colors.lightGreenAccent,
          textColor: Colors.white,
          fontSize: 16,
        );
      }
    });

    await BluetoothConnection.toAddress(mydevice?.address).then((_connection) async {
      print('Connected to the device' + mydevice.toString());
      connection = _connection;
    });
    connection.input.listen(_onDataReceived).onDone((){});
    connection.input.listen(null).onDone(() {
      print('Disconnected remotely!');
    });
  }

  void _sendMessage(String text) async {

    connection.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
    await connection.output.allSent;
  }

  Future<void> _disconnect() async {
    await _sendMessage('0');
    setState(() {
      op = "Disconnected";
      isConnectButtonEnabled = true;
      isDisConnectButtonEnabled = false;
    });
    connection.close();
    connection.dispose();
    Fluttertoast.showToast(
      msg: 'Disconnected',
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  Future<void> _onDataReceived(Uint8List data) async {
    await _sendMessage('1');
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    //String dataString = String.fromCharCodes(buffer);
    dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
          0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    decoder();
  }

  void results() {
    //Processing BAC
    setState(() {
      bac = double.parse(op);
      tts = bac * 3750;
      int h = tts ~/ 60;
      int m = (tts - 60 * h).round();
      tts1 = 'Time to sobriety: ' + h.toString() + ' h ' + m.toString() + ' m';
      final conversion = bac / 0.16; // so that the indicator shows proportionate level
        centreText = bac.toString();
        if (bac >= 0.08) {
          drinkingstatus = "Drinking status: Drunk";
          _animationController.value = conversion;
          myColor = Colors.red;
          sendSms();
        }
        else if (bac > 0.01 && bac < 0.08) {
          drinkingstatus = "Drinking status: Within limit";
          _animationController.value = conversion;
          myColor = Colors.amber;
        }
        else {
          drinkingstatus = "Drinking status: Sober";
          _animationController.value = conversion;
          myColor = Colors.green;
        }
    });
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy – HH:mm');
    final String formattedDate = formatter.format(now);
    FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid)
        .collection('BAC').doc()
        .set({'Date & Time of Record': formattedDate, 'BAC Level': centreText, 'Condition': drinkingstatus
    });
    store=0;
    }

  //Decode data from Bluetooth to op variable
  void decoder() {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Text((text) {
            return text == '/shrug' ? '¯\\_(ツ)_/¯' : op = text; //
          }(_message.text.trim()),),
        ],
      );
    }).toList();

    //Checking signal from Arduino
    if (checksec.hasMatch(op) == true) { //detect s from '20 s' data
      matches = exp.allMatches(op);
      matchedText = matches.elementAt(0).group(0); //parse the '10' from '10s'
      print(matchedText); // print the integer only without s
      var warmcountdown = int.parse(matchedText);
      print(warmcountdown);
      warmcentreText = ('Warming up ' + '$matchedText');
      centreText = warmcentreText;
      myColor = Colors.blue;
      _animationController.animateTo(1);
      _animationController.duration = Duration(seconds: 6);
      if (warmcountdown == 0) {
        _animationController.value = 0;
      }
      if (warmcountdown == 20) {
        drinkingstatus = '';
        tts1 = '';
      }
    }
    else if (re_bac.hasMatch(op) == true) {
      if(store==1) {
        results();
      }
    }
    else if (checksec2.hasMatch(op) == true) { //detect ss from '10 ss'
      matches2 = exp.allMatches(op);
      matchedText2 = matches2.elementAt(0).group(0); //parse the '10' from '10s'
      print(matchedText2); // print the integer only without s
      var blowountdown = int.parse(matchedText2);
      blowcentreText = ('Blow for ' + '$matchedText2');
      centreText = blowcentreText;
      myColor = Colors.blue;
      _animationController.animateTo(1);
      _animationController.duration = Duration(seconds: 3);
      if (blowountdown == 0) {
        _animationController.value = 0;
        store=1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Help'),
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
                  new ElevatedButton(
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
      ),
      appBar: AppBar(
        title: Text('Drinké Breathalyser'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
            margin: EdgeInsets.only(top: 20),
            child: Center(
              child: SizedBox(
                width: 300.0,
                height: 300.0,
                child: LiquidCircularProgressIndicator(
                  value: _animationController.value,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(myColor),
                  center: Text(
                    centreText,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: isConnectButtonEnabled,
                  child:
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: ElevatedButton.icon(
                          label: Text('Connect'),
                          icon: Icon(Icons.bluetooth_rounded),
                          onPressed: isConnectButtonEnabled ? _connect : null,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.greenAccent,
                            fixedSize: const Size (150,20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          )
                      )
                  ),
                ),
                Visibility(
                  visible: isDisConnectButtonEnabled,
                  child:
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: ElevatedButton.icon(
                          label: Text('Disconnect'),
                          icon: Icon(Icons.bluetooth_disabled_rounded),
                          onPressed: isDisConnectButtonEnabled ? _disconnect : null,
                            //1. pop up msg ask to reset on device
                            //2. run void() to refresh this page
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            fixedSize: const Size (150,20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          )
                      )
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('$drinkingstatus', style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold,),),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('$tts1', style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold,),),
            ),
          ),
        ],
      ),
    );
  }
}