import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class nativeBluetooth extends StatefulWidget {
  const nativeBluetooth({Key? key}) : super(key: key);

  @override
  _nativeBluetoothState createState() => _nativeBluetoothState();
}

class _nativeBluetoothState extends State<nativeBluetooth> {
  static const platform = const MethodChannel('flutter.native/helper');
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
  }

  Widget getWigetsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: bonded.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
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
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("paired devices"),
      ),
      body: bonded.length > 0 ? getWigetsList() : CircularProgressIndicator(),
    );
  }
}
