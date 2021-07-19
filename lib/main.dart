import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:security_cam/nativeBluetooth.dart';
import 'package:security_cam/webViewer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:flutter_blue/flutter_blue.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/video': (_) => WebViewer(),
        // '/bluetooth': (_) => FlutterBlueApp(),
        '/devicesList': (_) => nativeBluetooth(),
        '/nativeView': (_) => nativeView()
      },
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  static const platform = const MethodChannel('flutter.native/helper');

  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      // final int result = await platform.invokeMethod('getBatteryLevel');
      // batteryLevel = 'Battery level at $result % .';
      // print(batteryLevel);
      final int res = await platform.invokeMethod('getBluetoothStatus');
      print("Bluetooth status $res .");
      List<dynamic>? bonded = await platform.invokeMethod("getBondedDevices");
      print(bonded);
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
  }

  void postMessage() async {
    final url = 'http://192.168.0.161:5000/interrupt';
    final response =
        await http.post(Uri.parse(url), body: json.encode({'name': 'kalyan'}));
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RaspSecurity"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 70,
              color: Colors.blueAccent,
              child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/video');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Live Feed",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      Icon(
                        Icons.circle,
                        color: Colors.redAccent,
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 200,
              height: 70,
              color: Colors.blueAccent,
              child: TextButton(
                onPressed: () {
                  _getBatteryLevel();
                  //postMessage();
                },
                child: Text(
                  "Post",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 200,
              height: 70,
              color: Colors.blueAccent,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/bluetooth');
                },
                child: Text(
                  "Bluetooth",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 200,
              height: 70,
              color: Colors.blueAccent,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/devicesList');
                },
                child: Text(
                  "Start scan",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class nativeView extends StatefulWidget {
  const nativeView({Key? key}) : super(key: key);

  @override
  _nativeViewState createState() => _nativeViewState();
}

class _nativeViewState extends State<nativeView> {
  @override
  Widget build(BuildContext context) {
    final String viewType = 'hybrid-view-type';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: "hybrid-view-type",
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
