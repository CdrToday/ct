import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class Scan extends StatefulWidget {
  const Scan({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: new QrCamera(
          qrCodeCallback: (code) {
            print(code);
          },
        )
      )
    );
  }
}

