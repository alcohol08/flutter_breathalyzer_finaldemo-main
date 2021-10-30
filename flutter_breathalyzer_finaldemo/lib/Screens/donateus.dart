import 'package:flutter/material.dart';
import '../Components/buy_me_a_coffee_widget.dart';

class DonateUs extends StatefulWidget {
  @override
  _DonateUsState createState() => _DonateUsState();
}

class _DonateUsState extends State<DonateUs> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Donate to Drinké'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 50, 30, 0),
              child: Image(
                image: AssetImage('assets/qr-code.png'),
                height: 200,
                width: 200,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 50, 30, 0),
              child: Align(
                alignment: Alignment.center,
                child: BuyMeACoffeeWidget(
                    sponsorID: 'alcohol08'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: Text(
                'Your support will help us to continue developing the App and releasing more features in the future.' + '\n\n' +
                    'We are a group of students from School of Chemical and Biomedical Engineering NTU.' + '\n\n\n\n\n' +
                    '© 2021 DrinkÉ. All rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, color: Colors.black,
                ),
              ),
            ),
          ]
        ),
    );
  }
}
