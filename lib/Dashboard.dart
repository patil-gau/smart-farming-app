import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'package:flutter_vlc_player/vlc_player_controller.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _streamUrl;
  VlcPlayerController _vlcViewController;
  @override
  void initState() {
    super.initState();
    print("stream");
    _vlcViewController = new VlcPlayerController();
    _stream();
  }

  _stream() {
    print("Button");
    setState(() {
      _streamUrl = 'http://192.168.43.209:8080';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(
          "Tomato Plant",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: new Container(
          padding:
              const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
          child: Column(
            children: <Widget>[
              // First Sensore value Container
              ApiData(),

              SizedBox(height: 40),

              // Third Container for live streaming
              //     _streamUrl == null
              //         ? Container(
              //             child: Center(
              //               child: RichText(
              //                 text: TextSpan(children: [
              //                   TextSpan(
              //                     text: 'Stream Closed',
              //                     style: TextStyle(
              //                         fontSize: 14.0,
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.white,
              //                         background: Paint()..color = Colors.red),
              //                   )
              //                 ]),
              //               ),
              //             ),
              //           )
              //  :
              Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  height: 240,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[200],
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            // color: Colors.orange.shade200,
                            color: Colors.black12.withOpacity(0.4),
                            offset: Offset(3, 9),
                            blurRadius: 12.0,
                            spreadRadius: 2)
                      ]),
                  child: new VlcPlayer(
                    defaultHeight: 480,
                    defaultWidth: 640,
                    url: _streamUrl,
                    controller: _vlcViewController,
                    placeholder: Container(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class ApiData extends StatefulWidget {
  ApiData({Key key}) : super(key: key);
  @override
  _ApiDataState createState() => _ApiDataState();
}

class _ApiDataState extends State<ApiData> {
  double temp_val = 0.0;
  double moisture_val = 0.0;
  double ldr_val = 0.0;
  var fanState = "OFF";
  var motorState = "OFF";
  var lightState = "OFF";
  var val1;
  var val2;
  var val3;
  @override
  void initState() {
    super.initState();
    setUpTimedFetch();
    print("hello");
  }

  setUpTimedFetch() {
    print("fetch");
    Timer.periodic(Duration(seconds: 2), (timer) {
      fetchValues();
    });
  }

  void fetchValues() async {
    var response = await http.get(
      Uri.http("192.168.43.209:5000", "getValues"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final responseJson = jsonDecode(response.body);
    print(responseJson);
    val1 = responseJson['result']['temp_value'];
    val2 = responseJson['result']['moisture_value'];
    val3 = responseJson['result']['ldr_value'];

    setState(() {
      temp_val = val1.toDouble();
      moisture_val = val2.toDouble();
      ldr_val = val3.toDouble();
      fanState = responseJson['result']['fan_state'];
      motorState = responseJson['result']['motar_state'];
      lightState = responseJson['result']['light_state'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 30),
            height: 160,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[200],
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      // color: Colors.orange.shade200,
                      color: Colors.black12.withOpacity(0.4),
                      offset: Offset(3, 7),
                      blurRadius: 12.0,
                      spreadRadius: 2)
                ]),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Temp",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Moisture",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "LDR",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(15),
                      height: 50,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.greenAccent,
                      ),
                      child: Text(
                        " $temp_val 'c",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.greenAccent,
                      ),
                      child: Text(
                        " $moisture_val",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.greenAccent,
                      ),
                      child: Text(
                        "$ldr_val",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          // Second Actuatore Container
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 30),
            height: 160,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[200],
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      // color: Colors.orange.shade200,
                      color: Colors.black12.withOpacity(0.4),
                      offset: Offset(3, 7),
                      blurRadius: 12.0,
                      spreadRadius: 2)
                ]),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Fan",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Motor",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Light",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(15),
                      height: 50,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.greenAccent,
                      ),
                      child: Text(
                        "$fanState",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.greenAccent,
                      ),
                      child: Text(
                        "$motorState",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.greenAccent,
                      ),
                      child: Text(
                        "$lightState",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
