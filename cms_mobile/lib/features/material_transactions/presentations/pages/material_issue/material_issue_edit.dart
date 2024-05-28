import 'package:flutter/material.dart';

class MaterialIssueEditPage extends StatefulWidget {
  const MaterialIssueEditPage({super.key});

  @override
  State<MaterialIssueEditPage> createState() => _MaterialIssueEditPageState();
}

class _MaterialIssueEditPageState extends State<MaterialIssueEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Add Material'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Update Material Issue'),
              )
            ])
          ],
        ),
      ),
    );
  }
}
