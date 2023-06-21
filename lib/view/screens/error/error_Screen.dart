import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Screen'),
      ),
      body: Center(
        child: Text(
          error,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
