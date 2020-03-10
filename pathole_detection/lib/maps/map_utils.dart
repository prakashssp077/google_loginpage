import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class MapUtils{
  static Future<Uint8List>loadPinFromAsset(String path,{width = 100}) async{
    final byteData = await rootBundle.load(path);
    var bytes = byteData.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes,targetWidth: width);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    bytes = (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
    return bytes;
  }
}