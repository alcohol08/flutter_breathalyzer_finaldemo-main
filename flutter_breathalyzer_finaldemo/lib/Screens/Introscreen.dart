import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'login.dart';
//! sws

class IntroScreen extends StatefulWidget {

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Welcome to Drinké",
          body:
              "When it comes to alcohol, there is often a significant difference between how you feel and how impaired you actually are. "
                  "Drinké helps eliminate that uncertainty by giving you an actual number to put with that feeling, empowering you to make better decisions while drinking.",
          image: _buildImage('intro-1.png'),
          decoration: pageDecoration.copyWith(
            bodyFlex:2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          title: "Estimate Your Alcohol Level, With Pro-Grade Accuracy",
          body:
            "Powered by Drinké's professional-grade BACk® sensor technology, the device features simp"
            "le one button operation and delivers reliable and accurate BAC results you can trust, every time you test.",
          image: _buildImage('intro-2.png'),
          decoration: pageDecoration.copyWith(
            bodyFlex:2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          title: "Know When Your BAC Will Return to 0.00%",
          body:
          "Based on your last reading, Drinké's patented BACzero® technology estimates the time until your BAC will return to 0.00%. "
              "You might be surprised how long it takes before you’re actually sober.",
          decoration: pageDecoration.copyWith(
            bodyFlex:2,
            imageFlex: 3,
          ),
          image: _buildImage('intro-3.png'),
        ),
        PageViewModel(
          title: "Help to Notify Your Friend to Pick You Up",
          body:
          "Based on your BAC reading, Drinké is able for you to pre-set your close contact. If "
              "your BAC level exceeds the drink-driving limit, we can help you to notify your emergency contact about your current location to pick you up.",
          decoration: pageDecoration.copyWith(
            bodyFlex:2,
            imageFlex: 3,
          ),
          image: _buildImage('intro-4.png'),
        ),
        PageViewModel(
          title: "Easily Access to All Your Data in Cloud Encrypted Storage",
          body:
          "Drinké cares about your privacy, only you can access to your own BAC history measurements, with date. "
              "With this you can better track your alcohol drinking habits, or consult your physician.",
          decoration: pageDecoration.copyWith(
            bodyFlex:2,
            imageFlex: 3,
          ),
          image: _buildImage('intro-5.png'),
        ),
        PageViewModel(
          title: "Start the Journey Now!",
          body: "With Drinké device, paired with power of your smartphone, unlocks a variety of "
              "additional Drinké features that raise your drinking IQ.",
          decoration: pageDecoration.copyWith(
            bodyFlex:3,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('intro-6.png'),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
