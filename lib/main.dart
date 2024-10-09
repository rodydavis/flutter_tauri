import 'package:flutter/material.dart';

import 'tauri.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  String message = '';
  final controller = TextEditingController();

  Future<String> greet(String name) async {
    final result = await invoke('greet', {'name': name});
    return result as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: controller,
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () async {
                  final result = await greet(controller.text);
                  if (mounted) {
                    setState(() {
                      message = result;
                    });
                  }
                },
                child: const Text('Greet'),
              ),
              const SizedBox(height: 40),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
