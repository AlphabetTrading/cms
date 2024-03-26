import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoreTabScreen extends StatefulWidget {
  const StoreTabScreen({super.key});

  @override
  State<StoreTabScreen> createState() => _StoreTabScreenState();
}

const List<String> items = <String>[
  'Warehouse 1',
  'Warehouse 2',
  'Warehouse 3',
];

class _StoreTabScreenState extends State<StoreTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warehouses',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => context.goNamed("materials"),
                  child: Container(
                      height: 80,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: ShapeDecoration(
                          color: const Color(0x110F4A84),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          items[index],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text("72 Items"),
                        trailing: Text("View Details",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                      )),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
