// import 'dart:convert' show utf8;
// import 'dart:typed_data';

// import 'package:async/async.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
// import 'package:photo_view/photo_view.dart';

// class DetailPage extends StatefulWidget {
//   final BluetoothDevice server;

//   const DetailPage({required this.server});

//   @override
//   _DetailPageState createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   BluetoothConnection? connection = null;
//   bool isConnecting = true;

//   bool get isConnected => connection != null && connection!.isConnected;
//   bool isDisconnecting = false;

//   String? _selectedFrameSize;

//   List<List<int>> chunks = <List<int>>[];
//   int contentLength = 0;
//   Uint8List? _bytes;

//   late RestartableTimer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _selectedFrameSize = '0';
//     _getBTConnection();
//     print(widget.server.bondState);
//     _timer = new RestartableTimer(Duration(seconds: 1), _drawImage);
//   }

//   @override
//   void dispose() {
//     if (isConnected) {
//       isDisconnecting = true;
//       connection!.dispose();
//     }
//     _timer.cancel();
//     super.dispose();
//   }

//   _getBTConnection() async {
//     await BluetoothConnection.toAddress(widget.server.address)
//         .then((_connection) {
//       connection = _connection;
//       isConnecting = false;
//       isDisconnecting = false;
//       setState(() {});
//       connection!.input!.listen(_onDataReceived).onDone(() {
//         print(isDisconnecting);
//         if (isDisconnecting) {
//           print('Disconnecting locally');
//         } else {
//           print('Disconnecting remotely');
//         }
//         if (this.mounted) {
//           setState(() {});
//         }
//         print("here1");
//         Navigator.of(context).pop();
//       });
//     }).catchError((error) {
//       print(error);
//       Navigator.of(context).pop();
//     });
//   }

//   _drawImage() {
//     if (chunks.length == 0 || contentLength == 0) return;

//     _bytes = Uint8List(contentLength);
//     int offset = 0;
//     for (final List<int> chunk in chunks) {
//       _bytes!.setRange(offset, offset + chunk.length, chunk);
//       offset += chunk.length;
//     }

//     setState(() {});

//     SVProgressHUD.showInfo(status: "Downloaded...");
//     SVProgressHUD.setMaximumDismissTimeInterval(1000);

//     contentLength = 0;
//     chunks.clear();
//   }

//   void _onDataReceived(Uint8List data) {
//     if (data != null && data.length > 0) {
//       chunks.add(data);
//       contentLength += data.length;
//       _timer.reset();
//     }

//     print("Data Length: ${data.length}, chunks: ${chunks.length}");
//   }

//   void _sendMessage(String text) async {
//     text = text.trim();
//     if (text.length > 0) {
//       try {
//         connection!.output.add(Uint8List.fromList(utf8.encode(text)));
//         SVProgressHUD.show(status: "Requesting...");
//         await connection!.output.allSent;
//       } catch (e) {
//         setState(() {});
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           title: (isConnecting
//               ? Text('Connecting to ${widget.server.name} ...')
//               : isConnected
//                   ? Text('Connected with ${widget.server.name}')
//                   : Text('Disconnected with ${widget.server.name}')),
//         ),
//         body: SafeArea(
//           child: isConnected
//               ? Column(
//                   children: <Widget>[
//                     selectFrameSize(),
//                     shotButton(),
//                     photoFrame(),
//                   ],
//                 )
//               : Center(
//                   child: Text(
//                     "Connecting...",
//                     style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                 ),
//         ));
//   }

//   Widget photoFrame() {
//     return Expanded(
//       child: Container(
//         width: double.infinity,
//         child: _bytes != null
//             ? PhotoView(
//                 enableRotation: true,
//                 initialScale: PhotoViewComputedScale.covered,
//                 maxScale: PhotoViewComputedScale.covered * 2.0,
//                 minScale: PhotoViewComputedScale.contained * 0.8,
//                 imageProvider:
//                     Image.memory(_bytes!, fit: BoxFit.fitWidth).image,
//               )
//             : Container(),
//       ),
//     );
//   }

//   Widget shotButton() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: RaisedButton(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//             side: BorderSide(color: Colors.red)),
//         onPressed: () {
//           _sendMessage(_selectedFrameSize!);
//         },
//         color: Colors.red,
//         textColor: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'TAKE A SHOT',
//             style: TextStyle(fontSize: 24),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget selectFrameSize() {
//     return Container(
//         color: Colors.white,
//         padding: const EdgeInsets.all(16),
//         child: Text("Dropdown"));
//   }
// }
