import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes.dart';

class BluetoothTextFeild extends StatefulWidget {
  const BluetoothTextFeild({Key? key}) : super(key: key);

  @override
  _BluetoothTextFeildState createState() => _BluetoothTextFeildState();
}

class _BluetoothTextFeildState extends State<BluetoothTextFeild> {
  TextEditingController ssidController = TextEditingController();
  TextEditingController passController = TextEditingController();
  static const platform = const MethodChannel('flutter.native/helper');

  void dispose() {
    super.dispose();
    platform.invokeMethod("closeConnection");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text("Configure Wifi"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(25),
          children: [
            const SizedBox(height: 24),
            buildSSID(),
            const SizedBox(height: 24),
            buildPass(),
            const SizedBox(height: 40),
            makeButton(
                child: Text(
                  "Send",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                ontap: () async {
                  print(ssidController.text);
                  String wifiConfig =
                      '{"ssid":"${ssidController.text}","pass":"${passController.text}"}';
                  String res = await platform
                      .invokeMethod("sendData", {"data": wifiConfig});
                  print(res);
                }),
            const SizedBox(height: 40),
            makeButton(
                child: Text(
                  "Close Connection",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                ontap: () async {
                  print(ssidController.text);
                  final String res =
                      await platform.invokeMethod("closeConnection");
                  print(res);
                })
          ],
        ),
      ),
    );
  }

  Widget buildSSID() {
    return TextField(
      controller: ssidController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.green, width: 3),
        ),
        hintText: "Enter your wifi SSID",
        labelText: "Wifi SSID",
      ),
    );
  }

  Widget buildPass() {
    return TextField(
      controller: passController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.green, width: 3),
        ),
        hintText: "Enter your wifi Password",
        labelText: "Wifi Password",
      ),
    );
  }

  Widget buildSend() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 70,
      width: MediaQuery.of(context).size.width,
      color: Colors.blueAccent,
      child: TextButton(
        onPressed: () async {
          print(ssidController.text);
          String wifiConfig =
              '{"ssid":"${ssidController.text}","pass":"${passController.text}"}';
          String res =
              await platform.invokeMethod("sendData", {"data": wifiConfig});
          print(res);
        },
        child: Text(
          "Send",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }

  Widget buildClose() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 70,
      width: MediaQuery.of(context).size.width,
      color: Colors.blueAccent,
      child: TextButton(
        onPressed: () async {
          print(ssidController.text);
          final String res = await platform.invokeMethod("closeConnection");
          print(res);
        },
        child: Text(
          "Close Connection",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }

  Widget makeButton({required Widget child, required Function ontap}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: crls["primary"],
          borderRadius: BorderRadius.all(Radius.circular(10))),
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
