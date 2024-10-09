import 'dart:js_interop';

import 'package:web/web.dart';

extension type _Window._(Window _instance) implements Window {
  // ignore: non_constant_identifier_names
  external _Tauri get __TAURI__;
}

extension type _Tauri._(Window _instance) implements JSObject {
  external _TauriCore get core;
}

extension type _TauriCore._(Window _instance) implements JSObject {
  external JSPromise<JSAny> invoke(JSAny target, JSAny? args);
}

Future<Object?> invoke(String cmd, Map<String, Object?>? args) async {
  final result = await _Window._(window) //
      .__TAURI__
      .core
      .invoke(cmd.toJS, args?.jsify())
      .toDart;
  return result.dartify();
}
