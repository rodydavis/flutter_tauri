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
