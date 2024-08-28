import 'dart:io';
import 'dart:typed_data';
import 'package:auditfitnesstest/models/admin%20specific/campus_progress_table.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/admin/Tables/submited_weekly_audits.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Campusprogresstable extends StatefulWidget {
  final String? pre_year;
  final String? pre_month;
  final String? pre_weeknumber;
  final DateTime? pre_date;
  const Campusprogresstable(
      {super.key,
      required this.pre_year,
      required this.pre_month,
      required this.pre_weeknumber,
      this.pre_date});
  @override
  _CampusprogresstableState createState() => _CampusprogresstableState();
}

class _CampusprogresstableState extends State<Campusprogresstable> {
  DateTime _selectedDate = DateTime.now();
  String _selectedWeek = '';
  int year = 0;
  String month = '';
  int weekOfMonth = 0;
  String weekrange = '';
  List<CampusProgressTable> reports = [];
  List<Map<String, dynamic>> campusauditsDataJson = [];
  double maxColumnWidth = 200;
  int _totalObservations = 0;
  int _totalRemarks = 0;
  // late CampusProgressDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    if (widget.pre_year != null &&
        widget.pre_month != null &&
        widget.pre_weeknumber != null) {
      year = int.parse(widget.pre_year!);
      month = widget.pre_month!;
      _selectedWeek = widget.pre_weeknumber!;
    } else {
      _selectedWeek = _formatWeek(_selectedDate);
    }
    weekOfMonth = _getWeekOfMonth(widget.pre_date!);
    printWeekRange(int.parse(_selectedWeek), year);

    campusfetchData();

    // _dataSource = CampusProgressDataSource(reports: reports);
  }

  String _formatWeek(DateTime date) {
    int weekOfYear = _getWeekOfYear(date);
    setState(() {
      year = date.year;
      month = _getMonthName(date.month);
    });
    return weekOfYear.toString().padLeft(2, '0');
  }

  String _getMonthName(int monthIndex) {
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
      'December'
    ];
    return monthNames[monthIndex - 1];
  }

  int _getWeekOfYear(DateTime date) {
    var firstDayOfYear = DateTime(date.year, 1, 1);
    var daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    var weekNumber = ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
    return weekNumber;
  }

  int _getWeekOfMonth(DateTime date) {
    // Find the first day of the month
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    // Calculate the week number of the month
    int weekNumber = ((date.day + firstDayOfMonth.weekday - 1) / 7).ceil();
    return weekNumber;
  }

  Future<void> _pickWeek() async {
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
                initialSelectedDate: _selectedDate,
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
        _selectedDate = pickedDate;
        _selectedWeek = _formatWeek(pickedDate);
        campusfetchData();
      });
    }
  }

  Future<void> campusfetchData() async {
    try {
      final response = await http.get(Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.getcampusreports}/$_selectedWeek/$month/$year',
      ));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            reports = (jsonDecode(response.body) as List)
                .map((json) => CampusProgressTable.fromJson(json))
                .toList();
            campusauditsDataJson =
                reports.map((report) => report.toJson()).toList();

            _totalObservations = reports.fold(
                0, (sum, report) => sum + report.totalValidObservationCount);

            _totalRemarks = reports.fold(
                0, (sum, report) => sum + report.totalRemarksCount);

            isLoading = false;
          });
        }
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  String _formatWeekRange(int weekNumber, int year) {
    // Find the first day of the year
    DateTime firstDayOfYear = DateTime(year, 1, 1);

    // Calculate the start date of the given week number
    DateTime startDate = firstDayOfYear
        .add(Duration(days: (weekNumber - 1) * 7 - firstDayOfYear.weekday + 1));

    // Calculate the end date of the week
    DateTime endDate = startDate.add(Duration(days: 6));

    // Format the dates
    String formattedStartDate =
        '${startDate.day.toString().padLeft(2, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.year}';
    String formattedEndDate =
        '${endDate.day.toString().padLeft(2, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.year}';

    return '$formattedStartDate to $formattedEndDate';
  }

  void printWeekRange(int weekNumber, int year) {
    setState(() {
      weekrange = _formatWeekRange(weekNumber, year);
    });
  }

  Future<void> fetchPDF() async {
    try {
      if (!await _requestStoragePermission()) {
        print('Storage permission denied');
        return;
      }
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.pdfCampus);

      var headers = {'Content-Type': 'application/json'};
      var body = json.encode({
        "totalAreasCovered": _totalRemarks,
        "totalObservationsFound": _totalObservations,
        "date": weekrange,
        "taskId": reports[0].taskId,
        "analysisWeek": "$month $year (week $weekOfMonth)",
        "auditsData": campusauditsDataJson
      });
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final fileName = "$month(week test $weekOfMonth).pdf";
        final filePath = await _savePDF(response.bodyBytes, fileName);

        if (filePath != null) {
          await Future.delayed(const Duration(seconds: 1));
          await _openPDF(filePath);
        }
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Failed to download PDF";
      }
    } catch (error) {
      print('Error fetching PDF: $error');
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    final status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    } else {
      print('Storage permission denied.');
    }

    return false;
  }

  Future<String?> _savePDF(Uint8List pdfBytes, String fileName) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final path = directory.path;
        final file = File('$path/$fileName');

        await file.writeAsBytes(pdfBytes);
        // print('PDF saved at $path/$fileName');

        if (await file.exists()) {
          // print('File successfully saved.');
          return file.path;
        } else {
          print('File not found after save operation.');
        }
      } else {
        print('Failed to get storage directory.');
      }
    } catch (e) {
      print('Error saving PDF: $e');
    }
  }

  Future<void> _openPDF(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      print('Error opening PDF: ${result.message}');
    }
  }

  void choiceAction(String choice) {
    if (choice == MenuItems.selectWeek) {
      _pickWeek();
    } else if (choice == MenuItems.download) {
      fetchPDF();
    }
  }

  bool isLoading = true;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        titleSpacing: 0,
        actionsIconTheme: const IconThemeData(
          size: 30,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: Text(
          Provider.of<LanguageProvider>(context).isTamil
              ? "வளாக முன்னேற்ற \nஅறிக்கைகள்"
              : "Campus Progression \nReports",
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: Provider.of<LanguageProvider>(context).isTamil ? 20 : 25,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.visible,
        ),
        actions: [
          PopupMenuButton<String>(
              elevation: 0,
              iconColor: Colors.white,
              color: Colors.white,
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return MenuItems.choices.map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice,
                      child: ListTile(
                        title: Text(
                          choice,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Icon(
                          MenuItems.choiceIcons[choice],
                          color: Colors.black,
                        ),
                      ));
                }).toList();
              })
        ],
      ),
      backgroundColor: isLoading
          ? const Color.fromRGBO(229, 229, 228, 1)
          : const Color.fromRGBO(229, 229, 228, 1),
      body: isLoading
          ? const Center(
              child: SpinKitThreeBounce(
                color: Color.fromARGB(255, 97, 81, 188),
                size: 50,
              ),
            )
          : SfDataGridTheme(
              data: SfDataGridThemeData(
                // gridLineColor: Colors.black.withOpacity(0.3),
                // headerHoverColor: Colors.white.withOpacity(0.3),
                headerColor: const Color.fromRGBO(46, 46, 46, 1),
              ),
              child: SfDataGrid(
                columnWidthMode: ColumnWidthMode.auto,
                // rowHeight: 70.0, // Increase the height of each row
                headerRowHeight: 100.0, // Increase the height of the header row
                // shrinkWrapRows: true,
                // onQueryRowHeight: (details) {
                //   return details.getIntrinsicRowHeight(details.rowIndex);
                // },
                gridLinesVisibility: GridLinesVisibility.vertical,
                headerGridLinesVisibility: GridLinesVisibility.vertical,
                source: CampusProgressDataSource(
                  context: context,
                  reports: reports,
                ),
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'Main Area',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Main Area',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Task ID',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Task ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Specific Area',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Specific Area',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Audit Date',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Audit Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Observation',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Observations',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Action Taken',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Action Taken',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Status',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CampusProgressDataSource extends DataGridSource {
  final BuildContext context;
  final List<CampusProgressTable> reports;

  CampusProgressDataSource({
    required this.context,
    required this.reports,
  }) {
    dataGridRows = reports.expand((reports) {
      return reports.specificAreas!.map((area) {
        // Format the audit date to YYYY-MM-DD
        String formattedDate = "No Data available";
        if (area.auditDate != null && area.auditDate!.isNotEmpty) {
          DateTime parsedDate = DateTime.parse(area.auditDate!);
          formattedDate =
              "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
        }

        return DataGridRow(
          cells: [
            DataGridCell<String>(
                columnName: 'Main Area',
                value: reports.mainArea ?? "No Data available"),
            DataGridCell<String>(
                columnName: 'Task ID',
                value: reports.taskId ?? "No Data available"),
            DataGridCell<String>(
                columnName: 'Specific Area',
                value: area.specificArea ?? "No Data available"),
            DataGridCell<String>(
                columnName: 'Audit Date', value: formattedDate),
            DataGridCell<String>(
                columnName: 'Observation',
                value: area.reportObservation ?? "No Data available"),
            DataGridCell<String>(
                columnName: 'Action Taken',
                value: area.actionTaken ?? "No Data available"),
            DataGridCell<String>(
                columnName: 'Status',
                value: area.status ?? "No Data available"),
          ],
        );
      }).toList();
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];
  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = dataGridRows.indexOf(row);
    return DataGridRowAdapter(
      color: rowIndex.isEven ? Colors.grey[200] : Colors.white,
      cells: [
        for (var cell in row.getCells())
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            alignment: Alignment.centerLeft,
            child: cell.columnName == 'Status'
                ? FittedBox(
                    child: Text(
                      cell.value.toString(),
                      style: TextStyle(
                        color: cell.value.toString() == 'Completed'
                            ? Colors.green
                            : cell.value.toString() == 'In Progress'
                                ? Colors.red
                                : Colors.black,
                      ),
                    ),
                  )
                : Text(cell.value.toString()),
          ),
      ],
    );
  }
}
