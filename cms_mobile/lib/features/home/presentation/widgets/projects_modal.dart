import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightModal extends StatefulWidget {
  final String? weightId;
  WeightModal({this.weightId, super.key});

  @override
  State<WeightModal> createState() => _WeightModalState();
}

class _WeightModalState extends State<WeightModal> {
  Widget customDropdown(List<String> units) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return DropdownButton(
          value: dropDownValue,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          items: units
              .map<DropdownMenuItem<String>>(
                (unit) => DropdownMenuItem(
                  value: unit,
                  child: Text(
                    unit,
                    style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              dropDownValue = value!;
            });
          });
    });
  }

  String dropDownValue = 'kg';
  List<String> units = ['kg', 'lb'];
  final TextEditingController _weightTextController = TextEditingController();
  DateTime createdDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                        )),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: const Color(0XFFEBEBEB),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Date',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.black45)),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white54),
                          child: TextButton(
                            onPressed: () async {
                              createdDate = (await showDatePicker(
                                context: context,
                                initialDate: createdDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              ))!;
                              setState(() {});
                            },
                            child: Text(
                              DateFormat.yMMMd().format(createdDate),
                              style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black45),
                        ),
                        customDropdown(units)
                      ],
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Value',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.black45)),
                        SizedBox(
                          height: 40,
                          width: 80,
                          child: TextField(
                            controller: _weightTextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .black), // Set the border color here
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ));
    });
  }
}
