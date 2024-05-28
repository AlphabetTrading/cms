import 'package:flutter/material.dart';

class MaterialIssueDetailsPage extends StatefulWidget {
  const MaterialIssueDetailsPage({super.key});

  @override
  State<MaterialIssueDetailsPage> createState() =>
      _MaterialIssueDetailsPageState();
}

class _MaterialIssueDetailsPageState extends State<MaterialIssueDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [Text('Material Issue Detail')]),
    );
  }
}
