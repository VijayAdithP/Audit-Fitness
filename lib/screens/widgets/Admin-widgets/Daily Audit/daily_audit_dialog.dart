import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyAuditDialog extends StatefulWidget {
  const DailyAuditDialog({required this.onSave, super.key});
  final Function(String, DateTime) onSave;

  @override
  DailyAuditDialogState createState() => DailyAuditDialogState();
}

class DailyAuditDialogState extends State<DailyAuditDialog> {
  final TextEditingController _dailyauditIdController = TextEditingController();
  DateTime? _selectedDate;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Daily Audit"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            // keyboardType: TextInputType.,
            controller: _dailyauditIdController,
            decoration: const InputDecoration(labelText: "Daily Audit ID"),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _selectedDate == null
                      ? 'No date selected!'
                      : DateFormat.yMd().format(_selectedDate!).toString(),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectDate(context);
                  });
                },
                child: const Text('Select date'),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Save"),
          onPressed: () {
            widget.onSave(_dailyauditIdController.text, _selectedDate!);

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
