import 'package:flutter/material.dart';

class ShowInventoryScreen extends StatefulWidget {
  const ShowInventoryScreen({super.key});

  @override
  State<ShowInventoryScreen> createState() => _ShowInventoryScreenState();
}

class _ShowInventoryScreenState extends State<ShowInventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Inventory'),
      ),
      body: const Placeholder(),
    );
  }
}
