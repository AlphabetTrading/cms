import 'package:cms_mobile/features/home/presentation/pages/dashboard/detailed_expense_stats.dart';
import 'package:cms_mobile/features/home/presentation/pages/dashboard/detailed_stock_stats.dart';
import 'package:flutter/material.dart';

class DetailedStats extends StatefulWidget {
  @override
  _DetailedStatsState createState() => _DetailedStatsState();
}

class _DetailedStatsState extends State<DetailedStats> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Analytics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedIndex == 0
                              ? Colors.blue[100]
                              : Colors.transparent,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Expenses',
                            style: TextStyle(
                              color: _selectedIndex == 0
                                  ? Colors.blue
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedIndex == 1
                              ? Colors.blue[100]
                              : Colors.transparent,
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Stock',
                            style: TextStyle(
                              color: _selectedIndex == 1
                                  ? Colors.blue
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _selectedIndex == 0 ? DetailedExpenseStatsPage() : DetailedStockStatsPage(),
          ),
        ],
      ),
    );
  }
}

class ExpensesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Expenses Content Here',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class StocksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Stocks Content Here',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
