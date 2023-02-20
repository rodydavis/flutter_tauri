# Flutter + Tauri + Vite

This template should help get you started developing with Tauri in Flutter, JS/TS and Rust.

## Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Tauri](https://tauri.studio/en/docs/getting-started/intro)
- [Vite](https://vitejs.dev/guide/#scaffolding-your-first-vite-project)
- [VS Code](https://code.visualstudio.com/)
- [Rust](https://www.rust-lang.org/tools/install)
- [pnpm](https://pnpm.io/installation)

## Installation

```bash
pnpm install
flutter pub get
```

## Development

Run the VSCode task `Dev` to start the development server. This will start the Tauri dev server, the Flutter dev server.

## Build

Run the VSCode task `Build` to build the app. This will build the Flutter app, build the Tauri app and bundle the JS/TS app.

## Rust Code

Rust interop `src-tauri/src/main.rs`:

```rust
#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

// Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![greet])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

Rust dependencies can be added to `src-tauri/Cargo.toml`.

## JS/TS Code

JS/TS interop `src/api.ts`:

```javascript
import { invoke } from "@tauri-apps/api/tauri";

function invokeRust<T>(cmd: string, args: string): Promise<T> {
    return invoke(cmd, JSON.parse(args));
}

function evalJs(js: string): any {
    return eval(js);
}

declare global {
    interface Window {
        invokeRust: typeof invokeRust;
        evalJs: typeof evalJs;
    }
}

window.invokeRust = invokeRust;
window.evalJs = evalJs;

```

JS/TS dependencies can be added to `package.json`.

> Vite will build this file into `web/js` and Flutter will include it in the `web.index.html`.

## Flutter Code

Dart interop `lib/api.dart`:

```dart
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
```

Flutter dependencies can be added to `pubspec.yaml`.

Example usage in `lib/main.dart`:

```dart
import 'package:flutter/material.dart';

import 'api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter + Tauri + Vite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? rustMessage;
  String? jsMessage;

  @override
  void initState() {
    invokeRust('greet', {'name': 'Flutter'}).then((result) {
      if (mounted) {
        setState(() {
          rustMessage = result;
        });
      }
    });
    evalJs('(function() { return "Hello from JS"; })()').then((result) {
      if (mounted) {
        setState(() {
          jsMessage = result;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Rust says:'),
            subtitle: Text(rustMessage ?? 'Loading...'),
          ),
          ListTile(
            title: const Text('JS says:'),
            subtitle: Text(jsMessage ?? 'Loading...'),
          ),
        ],
      ),
    );
  }
}
```

## Recommended IDE Setup

- [VS Code](https://code.visualstudio.com/) + [Tauri](https://marketplace.visualstudio.com/items?itemName=tauri-apps.tauri-vscode) + [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer)
