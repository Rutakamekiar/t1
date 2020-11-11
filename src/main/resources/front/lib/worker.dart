@JS()
library sample;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:js/js.dart';
import 'package:image/image.dart' as im;

// -o web/worker.js lib/worker.dart

@JS('self')
external DedicatedWorkerGlobalScope get self;

void main() {
  self.onMessage.listen((e) {
    im.Image imageOriginal = im.decodeImage(e.data);
    int height = imageOriginal.height;
    int wight = imageOriginal.width;
    im.Image imageResized;
    if(height < wight) {
      imageResized = im.copyResize(imageOriginal, height: 100);
    } else {
      imageResized = im.copyResize(imageOriginal, width: 100);
    }
    print(imageResized.height.toString() + " " + imageResized.width.toString());
    var resizedBytes = im.encodeJpg(imageResized, quality: 100);
    self.postMessage(resizedBytes, null);
  });
}