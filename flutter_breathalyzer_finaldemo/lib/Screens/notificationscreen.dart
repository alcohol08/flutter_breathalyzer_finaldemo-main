import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:fluttertoast/fluttertoast.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var pickedtime;
  var _HH;
  var _MM;

  @override
  void initState() {
    super.initState();
  }

  void _picktime(){
    DatePicker.showTime12hPicker(context,
        currentTime: DateTime.now(), onConfirm: (DateTime time) {
          setState(() {
            pickedtime =
            'Daily Reminder at: ${time.hour} : ${time.minute}'
                '';
            _HH = '${time.hour}';
            _MM = '${time.minute}';
          });
        });
  }

  Future<void> scheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Drinké',
        'Reminder to take your BAC :)',
        picktime(const Time()),
        const NotificationDetails(
          android: AndroidNotificationDetails('drinke',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
    Fluttertoast.showToast(
      msg: 'Notification has been set',
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    Fluttertoast.showToast(
      msg: 'Notification has been opt out',
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  tz.TZDateTime picktime(Time time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day,
        int.parse('$_HH'), int.parse('$_MM'), 00);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Set a Reminder'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
    body: Column(
      children: <Widget>[
        const SizedBox(height: 30),
        FloatingActionButton.extended(
          onPressed: () { _picktime();
          },
          label: const Text('Pick a Time'),
          icon: const Icon(Icons.timer),
        ),
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Align(
            child: (pickedtime == null)
                ? const Text('Set a Daily Reminder to Measure your BAC', style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.bold,),)
                : Text('$pickedtime', style: const TextStyle(fontSize: 20,
              fontWeight: FontWeight.bold,),)
          ),
        ),
        const SizedBox(height: 30),
        FloatingActionButton.extended(
          onPressed: () async {
            await scheduleNotification();
          },
          label: const Text('Push Me Notification!'),
          icon: const Icon(Icons.send),
        ),
        const SizedBox(height: 30),
        FloatingActionButton.extended(
          onPressed: () async {
            await cancelNotifications(0);
          },
          label: const Text('Opt out from notification'),
          icon: const Icon(Icons.cancel),
        ),
          ],
        ),
  );
}
