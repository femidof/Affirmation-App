import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:affirmation_app/constants.dart';
import 'dart:convert';

class FetchQuote extends StatefulWidget {
  @override
  _FetchQuoteState createState() => _FetchQuoteState();
}

class _FetchQuoteState extends State<FetchQuote> {
  fetchQuote() async {
    var response = await http.get("$QUOTE_API_URL");
    var quote = jsonDecode(response.body)["affirmation"];
    print("$quote");
    return quote;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
