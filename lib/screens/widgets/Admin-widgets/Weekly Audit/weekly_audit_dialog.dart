import 'dart:convert';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/bad_condition_user.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WeeklyAuditDialog extends StatefulWidget {
  const WeeklyAuditDialog({super.key});

  @override
  WeeklyAuditDialogState createState() => WeeklyAuditDialogState();
}

class WeeklyAuditDialogState extends State<WeeklyAuditDialog> {
  final box = GetStorage();
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final TextEditingController _weeklyauditIdController =
      TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedWeek = '';
  int year = 0;
  String month = '';

  @override
  void dispose() {
    _weeklyauditIdController.dispose();
    super.dispose();
  }

  String _formatWeek(DateTime date) {
    int weekOfYear = _getWeekOfYear(date);
    setState(() {
      year = date.year;
    });
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    month = monthNames[date.month - 1];
    return weekOfYear.toString().padLeft(2, '0');
  }

  int _getWeekOfYear(DateTime date) {
    var firstDayOfYear = DateTime(date.year, 1, 1);
    var daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    var weekNumber = ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
    return weekNumber;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageProvider = Provider.of<LanguageProvider>(context);
  }

  late LanguageProvider _languageProvider;
  Future<void> createweeklytaskId() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.createweeklyauditId);

      var body = json.encode({
        "weekly_taskId": _weeklyauditIdController.text,
        "weekNumber": selectedWeek,
        "year": year,
        "month": month
      });

      var response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        // final SharedPreferences? prefs = await _prefs;
        String weeklyauditId = _weeklyauditIdController.text;
        // await prefs?.setString('weeklyauditId', weeklyauditId);
        DelightToastBar(
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
          animationDuration: const Duration(milliseconds: 100),
          snackbarDuration: const Duration(milliseconds: 800),
          builder: (context) => ToastCard(
            color: Colors.green,
            leading: const Icon(
              Icons.done,
              size: 28,
              color: Colors.white,
            ),
            title: Text(
              _languageProvider.isTamil
                  ? "வாராந்திர வேலை உருவாக்கப்பட்டது"
                  : "Weekly auditId created",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ).show(context);
        // print(jsonDecode(response.body)["Message"]);
        if (mounted) {
          setState(() {
            selectedWeek = '';
          });
        }
        Navigator.of(context).pop();
      } else if (response.statusCode == 400) {
        DelightToastBar(
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
          animationDuration: const Duration(milliseconds: 700),
          snackbarDuration: const Duration(seconds: 2),
          builder: (context) => ToastCard(
            color: Colors.red,
            leading: const Icon(
              Icons.notification_important_outlined,
              size: 28,
              color: Colors.white,
            ),
            title: Text(
              _languageProvider.isTamil
                  ? "பணி ஐடி ஏற்கனவே உள்ளது"
                  : "TaskId already exists",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ).show(context);
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Invalid Login";
      }
    } catch (error) {
      print(error);
    }
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 400,
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedDate: selectedDate,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  Navigator.of(context).pop(args.value);
                },
                todayHighlightColor: Colors.white,
                backgroundColor: Colors.black,
                selectionTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                selectionColor: Colors.white,
                monthCellStyle: const DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: Colors.black,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedWeek = _formatWeek(selectedDate);
      });
    }
  }

  String getWeekDateRange(int weekNumber, int year) {
    // Get the first day of the year
    DateTime firstDayOfYear = DateTime(year, 1, 1);

    // Calculate the start date of the week
    DateTime startOfWeek =
        firstDayOfYear.add(Duration(days: (weekNumber - 1) * 7));

    // Adjust to get the correct start of the week (Monday)
    startOfWeek = startOfWeek.subtract(Duration(days: startOfWeek.weekday - 1));

    // Calculate the end date of the week (Sunday)
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    // Format the date range
    String formattedRange = DateFormat('dd MMMM').format(startOfWeek) +
        ' To ' +
        DateFormat('dd MMMM').format(endOfWeek);

    return formattedRange;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.0),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 3,
            left: 3,
            right: 3,
            bottom: 3,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(37),
                bottomRight: Radius.circular(37),
                topLeft: Radius.circular(37),
                topRight: Radius.circular(37),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "வாராந்திர பணி ஐடி"
                          : "Weekly Task Id",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Badconditionields(
                      controller: _weeklyauditIdController,
                      hintText: Provider.of<LanguageProvider>(context).isTamil
                          ? "வேலை ஐடி"
                          : "Audit ID",
                    ),
                    const SizedBox(height: 20),
                    Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "வாராந்திர வேலை தேதி"
                          : "Weekly Audit Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        // height: 55,
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            selectedWeek.isEmpty
                                ? Provider.of<LanguageProvider>(context).isTamil
                                    ? "வாரம்"
                                    : 'Tap to select date'
                                : getWeekDateRange(
                                    int.parse(selectedWeek), year),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_weeklyauditIdController.text.isEmpty ||
                              year == 0 ||
                              month == "") {
                            DelightToastBar(
                              position: DelightSnackbarPosition.top,
                              autoDismiss: true,
                              snackbarDuration: Durations.extralong4,
                              builder: (context) => ToastCard(
                                color: Colors.red,
                                leading: const Icon(
                                  Icons.notification_important_outlined,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  _languageProvider.isTamil
                                      ? "அனைத்து புலங்களையும் நிரப்பவு"
                                      : "Fill all the fields",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ).show(context);
                          } else {
                            createweeklytaskId();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "உருவாக்கு"
                              : 'CREATE',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
