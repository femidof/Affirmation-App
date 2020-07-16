import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:affirmation_app/constants.dart';
import 'package:affirmation_app/unsplash/fetch_image.dart';
// import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void backgroundFetchHeadlessTask() async {
//   print("[BackgroundFetch] Headless event recieved");

//   // SharedPreferences preferences = await SharedPreferences.getInstance();

//   // BackgroundFetch.finish();
// }

void main() {
  runApp(MyApp());

  // Run On the Background
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
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
  }

  // Future<void> initPlatformState() async {}

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  void _showNotification() {}

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
  String quote;
  Future<String> fetchQuote() async {
    var response = await http.get("$QUOTE_API_URL");
    var quote = jsonDecode(response.body)["affirmation"];
    print("$quote");
    return quote;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(25),
      child: Center(
        child: FutureBuilder(
          future: fetchQuote(),
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
        // child: Text(
        //   "You'll find a way",
        //   style: TextStyle(color: Colors.white, fontSize: 30),
        // ),
      ),
    );
  }
}
