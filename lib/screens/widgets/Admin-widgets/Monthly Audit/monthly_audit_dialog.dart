import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MonthlyAuditDialog extends StatefulWidget {
  const MonthlyAuditDialog({super.key});

  @override
  MonthlyAuditDialogState createState() => MonthlyAuditDialogState();
}

class MonthlyAuditDialogState extends State<MonthlyAuditDialog> {
  String? selectedDate;
  final TextEditingController _monthlyAuditIdController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      final DateTime selected = args.value;
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        setState(() {
          selectedDate = DateFormat('yyyy-MM').format(selected);
        });
      });
    }
  }

  Widget getDateRangePicker() {
    return Container(
      height: 250,
      child: Card(
        child: SfDateRangePicker(
          view: DateRangePickerView.year,
          selectionMode: DateRangePickerSelectionMode.single,
          onSelectionChanged: selectionChanged,
          allowViewNavigation: false,
          showNavigationArrow: true,
          navigationMode: DateRangePickerNavigationMode.snap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Monthly Audit"),
      content: Container(
        width: MediaQuery.of(context).size.width - 30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _monthlyAuditIdController,
              decoration: const InputDecoration(labelText: "Monthly Audit ID"),
            ),
            const SizedBox(height: 20),
            getDateRangePicker(),
            selectedDate == null ? Text('Select a month') : Text(selectedDate!),
          ],
        ),
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
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
