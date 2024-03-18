import 'package:flutter/material.dart';

class RequestsTabScreen extends StatefulWidget {
  const RequestsTabScreen({super.key});

  @override
  State<RequestsTabScreen> createState() => _RequestsTabScreenState();
}

class _RequestsTabScreenState extends State<RequestsTabScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Requests'),
      ),
    );
  }
}
