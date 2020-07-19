import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:affirmation_app/constants.dart';
import 'package:affirmation_app/unsplash/fetch_image.dart';
// import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializing();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  Future<void> notifyOthers() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.cancelAll();
    Future<String> fetchQuote() async {
      var response = await http.get("$QUOTE_API_URL");
      var quote = jsonDecode(response.body)["affirmation"];

      return quote;
    }

    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Today\'s Quote',
        '${await fetchQuote()}', RepeatInterval.Daily, platformChannelSpecifics,
        payload: 'show payload content');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AFFIRMATION APP',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoadApp(),
    );
  }
}

class LoadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Affirmation App")),
      ),
      body: Stack(
        children: <Widget>[
          FetchImage(),
          DisplayQuote(),
        ],
      ),
    );
  }
}

class DisplayQuote extends StatefulWidget {
  @override
  _DisplayQuoteState createState() => _DisplayQuoteState();
}

class _DisplayQuoteState extends State<DisplayQuote> {
  // Future<String> _future;
  String quote;
  Future<String> fetchQuote() async {
    var response = await http.get("$QUOTE_API_URL");
    var quote = jsonDecode(response.body)["affirmation"];
    print("$quote");

    await MyApp().createState().notifyOthers();
    return quote;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(25),
      child: Center(
        child: StreamBuilder(
          stream: Stream.periodic(Duration(seconds: 50))
              .asyncMap((i) => fetchQuote()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              quote = snapshot.data;
              return Text(
                "$quote",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30),
              );
            } else {
              return Text(
                "You'll find a way",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30),
              );
            }
          },
        ),
      ),
    );
  }
}
