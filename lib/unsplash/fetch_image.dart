import 'dart:convert';
import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:affirmation_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchImage extends StatefulWidget {
  @override
  _FetchImageState createState() => _FetchImageState();
}

class _FetchImageState extends State<FetchImage> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> fetchImage() async {
    http.Response response = await http.get(UNSPLASH_API_URL,
        headers: <String, String>{
          'Accept-Version': 'v1',
          'Authorization': 'Client-ID $UNSPLASH_API_KEY'
        });
    if (response.statusCode != 200) {
      print("ERROR MTF");
      throw Exception(
          "Unexpected HTTP code: ${response.statusCode} ---- ${response.body}");
    }
    var data = jsonDecode(response.body);
    String url = data["urls"]["raw"];
    // print("from API print $url");
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: buildFutureBuilder(),
      ),
    );
  }

  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      // initialData:
      //     "https://images.unsplash.com/photo-1594576396046-503121b82768?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjE0ODI2MX0",
      future: fetchImage(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error from Unsplash API: ${snapshot.error}");
          return Container(
            child: Icon(
              Icons.cancel,
              size: 70,
              color: Colors.red,
            ),
          );
        } else if (snapshot.hasData) {
          print("photo: ${snapshot.data}");
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  snapshot.data,
                ),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 07, sigmaY: 07),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          );
        } else {
          return SpinKitFadingCube(
            color: Colors.deepPurple,
            size: 70,
          );
        }
      },
    );
  }
}
