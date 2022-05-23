import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import "package:intl/intl_browser.dart";

class QuakeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return QuakeAppState();
  }
}

class QuakeAppState extends State<QuakeApp> {
  late Future<Map<dynamic, dynamic>> _response;
  List finalResponse = [];
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _response = _getQuakes();
      _response.then((value) => value).then((value) {
        finalResponse = value['features'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.red.shade500,
        title: Text('Quakes'),
        centerTitle: true,
      ),
      body: Center(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: finalResponse.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Divider(
                      height: 2.0,
                      thickness: 1.0,
                    ),
                    ListTile(
                      subtitle: Text(
                        finalResponse[index]['properties']['title'],
                        style: TextStyle(fontSize: 15.0),
                      ),
                      title: Text(
                          (finalResponse[index]['properties']['time'] * 1000)
                              .toString()),
                      leading: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.green.shade400,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "${double.parse(finalResponse[index]['properties']['mag'].toStringAsFixed(1))}",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () => _showonTapMessage(
                          context, finalResponse[index]['properties']['place']),
                    ),
                  ],
                );
              })),
    );
  }
}

Future<Map> _getQuakes() async {
  String apiUrl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(Uri.parse(apiUrl));
  return jsonDecode(response.body);
}

void _showonTapMessage(BuildContext context, String message) {
  var alert = new AlertDialog(
    title: Text("Quakes"),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );
  showDialog(context: context, builder: (context) => alert);
}
