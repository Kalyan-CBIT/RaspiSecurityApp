import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:security_cam/bluetoothTextFeild.dart';
import 'package:security_cam/nativeBluetooth.dart';
import 'package:security_cam/webViewer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'themes.dart';
//import 'package:flutter_blue/flutter_blue.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      theme: ThemeData(
        primaryColor: crls["dominant"],
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/video': (_) => WebViewer(),
        '/bluetoothTextFeild': (_) => BluetoothTextFeild(),
        '/devicesList': (_) => NativeBluetooth(),
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
        brightness: Brightness.dark,
        title: Text("RaspSecurity"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(
              height: 40,
            ),
            makeButton(
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
                ),
                ontap: () {
                  Navigator.pushNamed(context, '/video');
                }),
            SizedBox(
              height: 40,
            ),
            makeButton(
                child: Text(
                  "Post",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                ontap: () {
                  Navigator.pushNamed(context, '/video');
                }),
            SizedBox(
              height: 40,
            ),
            makeButton(
                child: Text(
                  "Start Scan",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                ontap: () async {
                  final int res =
                      await platform.invokeMethod('getBluetoothStatus');
                  if (res == 1)
                    Navigator.pushNamed(context, '/devicesList');
                  else {
                    final snackBar = SnackBar(
                      content: Text('Please enable Bluetooth'),
                      action: SnackBarAction(
                        label: 'close',
                        onPressed: () {},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget makeButton({required Widget child, required Function ontap}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: crls["primary"]),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 70,
      child: TextButton(
          onPressed: () {
            ontap();
          },
          child: child),
    );
  }
}

// class nativeView extends StatefulWidget {
//   const nativeView({Key? key}) : super(key: key);

//   @override
//   _nativeViewState createState() => _nativeViewState();
// }

// class _nativeViewState extends State<nativeView> {
//   @override
//   Widget build(BuildContext context) {
//     final String viewType = 'hybrid-view-type';
//     // Pass parameters to the platform side.
//     final Map<String, dynamic> creationParams = <String, dynamic>{};

//     return AndroidView(
//       viewType: "hybrid-view-type",
//       layoutDirection: TextDirection.ltr,
//       creationParams: creationParams,
//       creationParamsCodec: const StandardMessageCodec(),
//     );
//   }
// }
