import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cdr_today/widgets/alerts.dart';
/// [DOC]: https://pub.dev/packages/permission_handler#status-of-the-permission

class Photos {
  static Future<bool> check(BuildContext context) async {
    PermissionStatus _p = await PermissionHandler().checkPermissionStatus(
      PermissionGroup.photos
    );
    
    if (_p != PermissionStatus.granted) {
      await alert(
        context,
        title: '相册权限',
        content: 'cdr.today 需要访问你的相册来进行图片上传，是否去应用设置中打开权限？',
        ok: Text('设置'),
        action: () async {
          await PermissionHandler().openAppSettings();
          Navigator.pop(context);
        }
      );
      return false;
    }
    
    return true;
  }
}

class Camera {
  static Future<bool> check(BuildContext context) async {
    PermissionStatus _p = await PermissionHandler().checkPermissionStatus(
      PermissionGroup.camera
    );
    
    if (_p != PermissionStatus.granted) {
      await alert(
        context,
        title: '相机权限',
        content: 'cdr.today 需要访问你的相机来进行扫码或拍照，是否去应用设置中打开权限？',
        ok: Text('设置'),
        action: () async {
          await PermissionHandler().openAppSettings();
          Navigator.pop(context);
        }
      );
      return false;
    }
    
    return true;
  }
}

class Storage {
  static Future<bool> check(BuildContext context) async {
    PermissionStatus _p = await PermissionHandler().checkPermissionStatus(
      PermissionGroup.storage
    );
    
    if (_p == PermissionStatus.disabled) {
      await alert(
        context,
        title: '存储权限',
        content: 'cdr.today 需要获取您的存储权限来进行图片存储，是否去应用设置中打开权限？',
        ok: Text('设置'),
        action: () async {
          await PermissionHandler().openAppSettings();
          Navigator.pop(context);
        }
      );
      return false;
    }
    
    return true;
  }
}

/// shortcuts
const checkPhotos = Photos.check;
const checkCamera = Camera.check;
const checkStorage = Storage.check;
