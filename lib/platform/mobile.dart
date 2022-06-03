import 'dart:io';
import 'myplatform.dart';

class PlatformUtil {
  static MyPlatform? myPlatform() {
    if (Platform.isAndroid) return MyPlatform.ANDROID;
    if (Platform.isIOS) return MyPlatform.IOS;
  }
}