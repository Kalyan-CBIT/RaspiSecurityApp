import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:security_cam/themes.dart';

class NativeBluetooth extends StatefulWidget {
  const NativeBluetooth({Key? key}) : super(key: key);

  @override
  _NativeBluetoothState createState() => _NativeBluetoothState();
}

class _NativeBluetoothState extends State<NativeBluetooth> {
  static const platform = const MethodChannel('flutter.native/helper');
  bool isEmpty = true;
  List<dynamic> bonded = [];
  void initState() {
    super.initState();
    getDevices();
    setState(() {});
  }

  void getDevices() async {
    try {
      final int res = await platform.invokeMethod('getBluetoothStatus');
      print("Bluetooth status $res .");
      bonded = await platform.invokeMethod("getBondedDevices");
      print(bonded);
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      isEmpty = false;
    });
  }

  Widget getWigetsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: bonded.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: crls["background2"],
          child: GestureDetector(
            onTap: () async {
              final bool res = await platform.invokeMethod(
                  "makeConnection", {"macAddr": bonded[index]["address"]});
              if (res)
                Navigator.pushNamed(context, '/bluetoothTextFeild');
              else
                print("Smething went wrong");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  bonded[index]["name"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(bonded[index]["address"])
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text("paired devices"),
      ),
      body: isEmpty ? CircularProgressIndicator() : getWigetsList(),
    );
  }
}
