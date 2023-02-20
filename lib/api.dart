@JS()
library static_interop;

import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_util';

import 'package:js/js.dart';

@JS()
@staticInterop
class JSWindow {}

extension JSWindowExtension on JSWindow {
  external Function invokeRust;
  external Function evalJs;
}

Future<T?> invokeRust<T>(String command, Map<String, Object?> args) async {
  try {
    final jsWindow = html.window as JSWindow;
    final argsJson = jsonEncode(args);
    final function = jsWindow.invokeRust(command, argsJson);
    final future = promiseToFuture(function);
    final result = await future;
    return result;
  } catch (e) {
    return null;
  }
}

Future<T?> evalJs<T>(String code) async {
  try {
    final jsWindow = html.window as JSWindow;
    final function = jsWindow.evalJs(code);
    final result = function;
    return result;
  } catch (e) {
    return null;
  }
}
