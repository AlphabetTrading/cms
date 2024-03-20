import 'package:flutter/material.dart';

class StoreTabScreen extends StatefulWidget {
  const StoreTabScreen({super.key});

  @override
  State<StoreTabScreen> createState() => _StoreTabScreenState();
}

class _StoreTabScreenState extends State<StoreTabScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Store'),
      ),
    );
  }
}
