import 'dart:convert';

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
    fetchImage();
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
    //* Remove print(url);
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

  FutureBuilder<String> buildFutureBuilder() {
    return FutureBuilder(
      future: fetchImage(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            Text("An Error Occured");
            break;

          case ConnectionState.waiting:
            Text("Loading and waiting");
            break;

          case ConnectionState.active:
            Text("Connected and Waiting");
            break;

          default:
            Text("WoW");
        }

        // if (snapshot.hasError) {
        //   print("Error from Unsplash API");
        // }
        return Text("${snapshot.data}");
      },
    );
  }
}
