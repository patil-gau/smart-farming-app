import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'localization_service.dart';
import 'package:get/get.dart';
import 'package:flutter_switch/flutter_switch.dart';
// import 'package:flutter_vlc_player/vlc_player.dart';
// import 'package:flutter_vlc_player/vlc_player_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //this code is there for adding camera module
  // String _streamUrl;
  // VlcPlayerController _vlcViewController;
  // @override
  // void initState() {
  //   super.initState();
  //   print("stream");
  //   _vlcViewController = new VlcPlayerController();
  //   _stream();
  // }

  // _stream() {
  //   print("Button");
  //   setState(() {
  //     _streamUrl = 'http://192.168.43.209:8080';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text(
          "title".tr,
          style: TextStyle(color: Colors.white),
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
              // Container(
              //     padding: const EdgeInsets.only(top: 20, bottom: 30),
              //     height: 240,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5),
              //         color: Colors.grey[200],
              //         boxShadow: <BoxShadow>[
              //           BoxShadow(
              //               // color: Colors.orange.shade200,
              //               color: Colors.black12.withOpacity(0.4),
              //               offset: Offset(3, 9),
              //               blurRadius: 12.0,
              //               spreadRadius: 2)
              //         ]),
              //     child: new VlcPlayer(
              //       defaultHeight: 480,
              //       defaultWidth: 640,
              //       url: _streamUrl,
              //       controller: _vlcViewController,
              //       placeholder: Container(),
              //     )),
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
  String lng;
  double temp_val = 0.0;
  double moisture_val = 0.0;
  double ldr_val = 0.0;
  bool mode = true;

  bool manual_fan = false;
  bool manual_light = false;
  bool manual_pump = false;

  var fanState = "OFF";
  var motorState = "OFF";
  var lightState = "OFF";
  var val1;
  var val2;
  var val3;
  @override
  void initState() {
    super.initState();
    lng = LocalizationService().getCurrentLang();
    setUpTimedFetch();
  }

  setUpTimedFetch() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      fetchValues();
    });
  }

  void fetchValues() async {
    var response = await http.get(
      Uri.http("192.168.43.140:8000", "getValues"),
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

  void selectmode(String mode) async {
    var response =
        await http.post(Uri.http("192.168.43.140:8000", "selectmode"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({"mode": mode}));
  }

  void controlActuatorsMannualy(String actuatorName, bool state) async {
    String endpoint = "";
    if (actuatorName == "fan") {
      endpoint = "fan";
    } else if (actuatorName == "light") {
      endpoint = "light";
    } else {
      endpoint = "motar";
    }

    var response = await http.post(Uri.http("192.168.43.140:8000", endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({"mode": "manual", "state": state}));

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   "title".tr,
              //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              // ),
              FlutterSwitch(
                width: 70.0,
                height: 30.0,
                valueFontSize: 10.0,
                toggleSize: 45.0,
                value: mode,
                borderRadius: 30.0,
                padding: 8.0,
                showOnOff: true,
                onToggle: (val) {
                  setState(() {
                    mode = val;
                    if (mode == true) {
                      selectmode("auto");
                    } else {
                      selectmode("manual");
                    }
                  });
                },
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Select Language",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("       "),
              new DropdownButton<String>(
                items: LocalizationService.langs.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                value: this.lng,
                underline: Container(color: Colors.transparent),
                isExpanded: false,
                onChanged: (newVal) {
                  setState(() {
                    this.lng = newVal;
                    LocalizationService().changeLocale(newVal);
                  });
                },
              ),
            ],
          ),
          mode
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      height: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.greenAccent,
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
                                "Temp".tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Moisture".tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "LDR".tr,
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
                                  color: Colors.lime,
                                ),
                                child: Text(
                                  " $temp_val 'c",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.lime,
                                ),
                                child: Text(
                                  " $moisture_val",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.lime,
                                ),
                                child: Text(
                                  "$ldr_val",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
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
                          color: Colors.greenAccent,
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
                                "Fan".tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Pump".tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Light".tr,
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
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.orange,
                                ),
                                child: Text(
                                  "$fanState",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.orange,
                                ),
                                child: Text(
                                  "$motorState",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.orange,
                                ),
                                child: Text(
                                  "$lightState",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Second Actuatore Container
                    Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      height: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.greenAccent,
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
                                "Fan".tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Pump".tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Light".tr,
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
                                // height: 50,
                                // width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.orange,
                                ),
                                child: FlutterSwitch(
                                  width: 50.0,
                                  height: 30.0,
                                  valueFontSize: 10.0,
                                  toggleSize: 15.0,
                                  value: manual_fan,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      manual_fan = val;
                                      if (manual_fan == true) {
                                        controlActuatorsMannualy("fan", true);
                                      } else {
                                        controlActuatorsMannualy("fan", false);
                                      }
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                // height: 50,
                                // width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.orange,
                                ),
                                child: FlutterSwitch(
                                  width: 50.0,
                                  height: 30.0,
                                  valueFontSize: 10.0,
                                  toggleSize: 15.0,
                                  value: manual_pump,
                                  borderRadius: 30.0,
                                  padding: 8.0,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      manual_pump = val;
                                      if (manual_pump == true) {
                                        controlActuatorsMannualy("motar", true);
                                      } else {
                                        controlActuatorsMannualy(
                                            "motar", false);
                                      }
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                // height: 50,
                                // width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.orange,
                                ),
                                child: FlutterSwitch(
                                  width: 50.0,
                                  height: 30.0,
                                  valueFontSize: 10.0,
                                  toggleSize: 15.0,
                                  value: manual_light,
                                  borderRadius: 30.0,
                                  padding: 5.0,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      manual_light = val;
                                      if (manual_light == true) {
                                        controlActuatorsMannualy("light", true);
                                      } else {
                                        controlActuatorsMannualy(
                                            "light", false);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
