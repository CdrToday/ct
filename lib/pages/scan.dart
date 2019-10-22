import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/x/permission.dart' as pms;

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<Scan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(),
        backgroundColor: Colors.transparent,
        trailing: QrRefresher(
          widget: CtNoRipple(
            icon: Icons.photo,
            onTap: _pickImage
          )
        ),
        border: null,
      ),
      child: GestureDetector(
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.white,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 300,
          ),
        ),
        onTap: () => controller?.toggleFlash(),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _pickImage() async {
    if (await pms.checkPhotos(context) == false) return;
    final _bloc = BlocProvider.of<RefreshBloc>(context);
    
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    _bloc.dispatch(Refresh(qr: true));
    String code = await QrCodeToolsPlugin.decodeFrom(image.path);
    if (code == null) {
      info(context, '二维码识别失败，请重试');
      _bloc.dispatch(Refresh(qr: false));
      return;
    }

    Map<String, dynamic> args = jsonDecode(code);
    Navigator.popAndPushNamed(
      context, '/qrcode/join',
      arguments: QrCodeArgs(
        code: args['code'],
        name: args['name']
      ),
    );

    _bloc.dispatch(Refresh(qr: false));
  }
  
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
        Map<String, String> args = jsonDecode(scanData);
        if (scanData == null) {
          info(context, '二维码识别失败，请重试');
          return;
        }

        Navigator.pushNamed(
          context, '/qrcode/join',
          arguments: QrCodeArgs(
            code: args['code'],
            name: args['name']
          ),
        );
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
