import 'dart:io';
import 'dart:typed_data';
import 'package:auditfitnesstest/models/admin%20specific/weekly%20models/new_weekly_report.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/admin/campus_progress_edit.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MenuItems {
  static const String selectWeek = 'Select Week';
  static const String download = 'Download';

  static const List<String> choices = <String>[selectWeek, download];

  // for icons
  static const Map<String, IconData> choiceIcons = <String, IconData>{
    selectWeek: Icons.calendar_month_rounded,
    download: Icons.download_rounded,
  };
}

class WeeklyReportPage extends StatefulWidget {
  final String? preyear;
  final String? premonth;
  final String? preweeknumber;
  final DateTime? predate;
  const WeeklyReportPage(
      {super.key,
      required this.preyear,
      required this.premonth,
      required this.preweeknumber,
      this.predate});

  @override
  _WeeklyReportPageState createState() => _WeeklyReportPageState();
}

class _WeeklyReportPageState extends State<WeeklyReportPage> {
  DateTime selectedDate = DateTime.now();
  String selectedWeek = '';
  int year = 0;
  String month = '';
  int weekOfMonth = 0;
  String weekrange = '';
  List<NewWeeklyReport> reports = [];
  List<Map<String, dynamic>> auditsDataJson = [];
  double maxColumnWidth = 200;
  bool isimagethere = false;
  int totalObservations = 0;
  int totalRemarks = 0;
  // late ReportDataSource _reportDataSource;

  @override
  void initState() {
    super.initState();

    if (widget.preyear != null &&
        widget.premonth != null &&
        widget.preweeknumber != null) {
      year = int.parse(widget.preyear!);
      month = widget.premonth!;
      selectedWeek = widget.preweeknumber!;
    } else {
      selectedWeek = _formatWeek(selectedDate);
    }
    weekOfMonth = _getWeekOfMonth(widget.predate!);
    printWeekRange(int.parse(selectedWeek), year);

    fetchData();
    // _reportDataSource = ReportDataSource(context: context, reports: reports);
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
            child: SizedBox(
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
        selectedWeek = _formatWeek(pickedDate);
        fetchData();
      });
    }
  }

  bool isLoading = true;

  Future<void> fetchData() async {
    // print(selectedWeek);
    // print(month);
    // print(year);
    try {
      final response = await http.get(Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.getweeklyreports}/$selectedWeek/$month/$year',
      ));

      if (response.statusCode == 200) {
        // print(response.body);
        // final data = (jsonDecode(response.body) as List)
        //     .map((json) => NewWeeklyReport.fromJson(json))
        //     .toList();

        setState(() {
          reports = (jsonDecode(response.body) as List)
              .map((json) => NewWeeklyReport.fromJson(json))
              .toList();
          auditsDataJson = reports.map((report) => report.toJson()).toList();
          // Calculating the total valid observations
          totalObservations = reports.fold(
              0, (sum, report) => sum + report.totalValidObservationCount);

          totalRemarks =
              reports.fold(0, (sum, report) => sum + report.totalRemarksCount);
          // print(totalRemarks);
          isLoading = false;
        });
        // print(reports);
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

  int _getWeekOfMonth(DateTime date) {
    // Find the first day of the month
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    // Calculate the week number of the month
    int weekNumber = ((date.day + firstDayOfMonth.weekday - 1) / 7).ceil();
    return weekNumber;
  }

  Future<void> fetchPDF() async {
    try {
      if (!await _requestStoragePermission()) {
        print('Storage permission denied');
        return;
      }
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.pdfWeekly);

      var headers = {'Content-Type': 'application/json'};
      var body = json.encode({
        "totalAreasCovered": totalRemarks,
        "totalObservationsFound": totalObservations,
        "date": weekrange,
        "taskId": reports[0].taskId,
        "analysisWeek": "$month $year (week $weekOfMonth)",
        "auditsData": auditsDataJson,
      });
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final fileName = "$month(week $weekOfMonth).pdf";
        final filePath = await _savePDF(response.bodyBytes, fileName);
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
              Provider.of<LanguageProvider>(context).isTamil
                  ? "பணி ஐடி ஏற்கனவே உள்ளது"
                  : "PDF successfully downloaded",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ).show(context);

        if (filePath != null) {
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
                Provider.of<LanguageProvider>(context).isTamil
                    ? "பணி ஐடி ஏற்கனவே உள்ளது"
                    : "PDF successfully downloaded",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ).show(context);
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

        // Confirm the file is saved successfully
        if (await file.exists()) {
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
                Provider.of<LanguageProvider>(context).isTamil
                    ? "பணி ஐடி ஏற்கனவே உள்ளது"
                    : "PDF successfully downloaded",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ).show(context);
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

  // Widget _buildHeaderCell(String text, double width) {
  //   return Container(
  //     width: width,
  //     height: 150,
  //     decoration: BoxDecoration(
  //       boxShadow: [
  //         BoxShadow(
  //           offset: Offset.fromDirection(12.6, 5.0),
  //           color: Colors.grey[500]!,
  //           blurRadius: 6,
  //         ),
  //       ],
  //       border: const Border(
  //         bottom: BorderSide(),
  //       ),
  //       color: Colors.grey[200],
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.only(
  //         left: 15.0,
  //       ),
  //       child: Align(
  //         alignment: Alignment.centerLeft,
  //         child: Text(
  //           text,
  //           style: TextStyle(
  //             fontSize:
  //                 Provider.of<LanguageProvider>(context).isTamil ? 17 : 20,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDataCell(String text, double width, double height) {
  //   return Container(
  //     width: width,
  //     height: height,
  //     decoration: BoxDecoration(
  //       boxShadow: [
  //         BoxShadow(
  //           offset: Offset.fromDirection(6.5, 5.0),
  //           color: Colors.grey[500]!,
  //           blurRadius: 6,
  //         ),
  //       ],
  //       border: const Border(
  //         bottom: BorderSide(),
  //       ),
  //       color: Colors.grey[200],
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Center(
  //         child: Text(
  //           text,
  //           style: const TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // List<String?> parseRemarkData(String? remarks) {
  //   if (remarks == null) return [];

  //   // Split the remarks string by commas and trim each entry
  //   List<String?> remarkList = remarks.split(',').map((s) => s.trim()).toList();

  //   // Remove entries that are empty or "No data"
  //   remarkList.removeWhere((remark) =>
  //       remark == null || remark.isEmpty || remark.toLowerCase() == 'no data');

  //   return remarkList;
  // }

  // Widget _buildNestedDataCell(
  //   List<String?> data,
  //   double width,
  //   double height,
  //   bool isImageColumn,
  //   bool isDateColumn,
  //   bool isRemarkColumn,
  //   List<String?>? imageData,
  //   int mainAreaIndex,
  //   String mainArea,
  //   String taskid,
  //   List<NewWeeklyReport> reports,
  // ) {
  //   return Container(
  //     width: width,
  //     height: height,
  //     decoration: BoxDecoration(
  //       border: const Border(
  //         bottom: BorderSide(),
  //       ),
  //       color: Colors.grey[200],
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: data.asMap().entries.map((entry) {
  //         int index = entry.key;
  //         String? item = entry.value;

  //         if (isDateColumn && item != null) {
  //           try {
  //             DateTime parsedDate = DateTime.parse(item);
  //             item = DateFormat('yyyy-MM-dd').format(parsedDate);
  //           } catch (e) {
  //             item = item;
  //           }
  //         }
  //         return Container(
  //           width: width,
  //           decoration: BoxDecoration(
  //             border: Border(
  //               top: index == 0 ? BorderSide.none : const BorderSide(),
  //             ),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(15.0),
  //             child: isImageColumn
  //                 ? (item == null)
  //                     ? GestureDetector(
  //                         onTap: () {
  //                           String specificArea = reports[mainAreaIndex]
  //                                   .specificAreas?[index]
  //                                   .specificArea ??
  //                               'No data';
  //                           String reportObservation = reports[mainAreaIndex]
  //                                   .specificAreas?[index]
  //                                   .reportObservation ??
  //                               'No data';
  //                           String auditdate = reports[mainAreaIndex]
  //                                   .specificAreas?[index]
  //                                   .auditDate ??
  //                               'No data';
  //                           if (specificArea == 'no data') {
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                 builder: (context) => CampusProgressEdit(
  //                                   taskid: taskid,
  //                                   mainArea: mainArea,
  //                                   specificArea: specificArea,
  //                                   reportObservation: reportObservation,
  //                                   auditDate: auditdate,
  //                                   month: month,
  //                                   weeknumber: selectedWeek,
  //                                   year: year,
  //                                 ),
  //                               ),
  //                             );
  //                           }
  //                         },
  //                         child: Text(
  //                           Provider.of<LanguageProvider>(context).isTamil
  //                               ? "படம் இல்லை"
  //                               : 'No Image',
  //                           style: TextStyle(
  //                             // color: Colors.deepPurple,
  //                             fontSize:
  //                                 Provider.of<LanguageProvider>(context).isTamil
  //                                     ? 16.5
  //                                     : 18,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       )
  //                     : GestureDetector(
  //                         onTap: () => _showImageDialog(
  //                           context,
  //                           item ?? '',
  //                           mainArea, // Pass mainArea
  //                           taskid,
  //                           mainAreaIndex,
  //                           index, // Pass the specific area index
  //                           reports,
  //                         ),
  //                         child: Text(
  //                           Provider.of<LanguageProvider>(context).isTamil
  //                               ? "படங்களை பார்க்கவும்"
  //                               : 'View Images',
  //                           style: TextStyle(
  //                             color: Colors.deepPurple,
  //                             fontSize:
  //                                 Provider.of<LanguageProvider>(context).isTamil
  //                                     ? 16.5
  //                                     : 18,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       )
  //                 : Text(
  //                     item ?? "no data",
  //                     style: const TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  // void _showImageDialog(
  //   BuildContext context,
  //   String imageUrls,
  //   String mainArea,
  //   String taskid,
  //   int mainAreaIndex,
  //   int specificAreaIndex,
  //   List<NewWeeklyReport> reports,
  // ) {
  //   final String baseUrl = '${ApiEndPoints.baseUrl}/';
  //   List<String> urls = imageUrls.split(',').map((url) {
  //     String formattedUrl =
  //         baseUrl + url.trim().replaceAll('\\', '/').replaceAll(' ', '%20');
  //     return formattedUrl;
  //   }).toList();

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(40.0),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(40.0),
  //           child: Padding(
  //             padding: const EdgeInsets.all(3),
  //             child: Container(
  //               decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.all(Radius.circular(37)),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(
  //                     horizontal: 20.0, vertical: 10),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     const Text(
  //                       "Images",
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 17,
  //                       ),
  //                     ),
  //                     SingleChildScrollView(
  //                       scrollDirection: Axis.horizontal,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: urls.map((url) {
  //                           return Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: GestureDetector(
  //                               onTap: () {
  //                                 showDialog(
  //                                   context: context,
  //                                   builder: (_) => imageDialog(url, context),
  //                                 );
  //                               },
  //                               child: Container(
  //                                 height: 200,
  //                                 width: 200,
  //                                 decoration: BoxDecoration(
  //                                   border: Border.all(
  //                                     width: 2,
  //                                     color: Colors.white,
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(10),
  //                                 ),
  //                                 child: ClipRRect(
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   child: CachedNetworkImage(
  //                                     imageUrl: url,
  //                                     fit: BoxFit.fill,
  //                                     placeholder: (context, url) =>
  //                                         const Center(
  //                                       child: CircularProgressIndicator(),
  //                                     ),
  //                                     errorWidget: (context, url, error) =>
  //                                         const Icon(
  //                                       Icons.error,
  //                                       color: Colors.red,
  //                                       size: 50,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         }).toList(),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 50,
  //                       width: 300,
  //                       child: ElevatedButton(
  //                         onPressed: () {
  //                           String specificArea = reports[mainAreaIndex]
  //                                   .specificAreas?[specificAreaIndex]
  //                                   .specificArea ??
  //                               'No data';
  //                           String reportObservation = reports[mainAreaIndex]
  //                                   .specificAreas?[specificAreaIndex]
  //                                   .reportObservation ??
  //                               'No data';
  //                           String auditdate = reports[mainAreaIndex]
  //                                   .specificAreas?[specificAreaIndex]
  //                                   .auditDate ??
  //                               'No data';
  //     print(specificArea);
  //     print(reportObservation);
  //     print(auditdate);
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => CampusProgressEdit(
  //       taskid: taskid,
  //       mainArea: mainArea,
  //       specificArea: specificArea,
  //       reportObservation: reportObservation,
  //       auditDate: auditdate,
  //       month: month,
  //       weeknumber: selectedWeek,
  //       year: year,
  //     ),
  //   ),
  // );
  //                           // Here, navigate to another page or handle accordingly
  //                           // Navigator.pop(context); // Close the dialog
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(20.0),
  //                           ),
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 50, vertical: 15),
  //                           backgroundColor: Colors.black,
  //                         ),
  //                         child: const Text(
  //                           'CREATE CAMPUS ID',
  //                           style: TextStyle(
  //                             fontSize: 14,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget imageDialog(String url, BuildContext context) {
  //   return Dialog(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         CachedNetworkImage(
  //           imageUrl: url,
  //           fit: BoxFit.contain,
  //           placeholder: (context, url) => const Center(
  //             child: CircularProgressIndicator(),
  //           ),
  //           errorWidget: (context, url, error) => const Icon(
  //             Icons.error,
  //             color: Colors.red,
  //             size: 50,
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Close'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _showImageDialog(
  //   BuildContext context,
  //   String imageUrls,
  //   String mainArea,
  //   String taskid,
  //   int mainAreaIndex,
  //   int specificAreaIndex,
  //   List<NewWeeklyReport> reports,
  // ) {
  //   final String baseUrl = '${ApiEndPoints.baseUrl}/';
  //   List<String> urls = imageUrls.split(',').map((url) {
  //     String formattedUrl =
  //         baseUrl + url.trim().replaceAll('\\', '/').replaceAll(' ', '%20');
  //     print('Formatted URL: $formattedUrl');
  //     return formattedUrl;
  //   }).toList();

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(40.0),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(40.0),
  //           child: Padding(
  //             padding: const EdgeInsets.only(
  //               top: 3,
  //               left: 3,
  //               right: 3,
  //               bottom: 3,
  //             ),
  //             child: Container(
  //               decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(37),
  //                   bottomRight: Radius.circular(37),
  //                   topLeft: Radius.circular(37),
  //                   topRight: Radius.circular(37),
  //                 ),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(
  //                     horizontal: 20.0, vertical: 10),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Text(
  //                       Provider.of<LanguageProvider>(context).isTamil
  //                           ? "படம்"
  //                           : "Image",
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 17,
  //                       ),
  //                     ),
  //                     SingleChildScrollView(
  //                       scrollDirection: Axis.horizontal,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: urls.map((url) {
  //                           return Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: GestureDetector(
  //                                 onTap: () async {
  //                                   if (isimagethere) {
  //                                     await showDialog(
  //                                       context: context,
  //                                       builder: (_) =>
  //                                           imageDialog(url, context),
  //                                     );
  //                                   }
  //                                 },
  //                                 child: Container(
  //                                   height: 200,
  //                                   width: 200,
  //                                   decoration: BoxDecoration(
  //                                     border: Border.all(
  //                                       width: 2,
  //                                       color: Colors.white,
  //                                     ),
  //                                     borderRadius: BorderRadius.circular(10),
  //                                   ),
  //                                   child: Stack(
  //                                     fit: StackFit.expand,
  //                                     children: [
  //                                       ClipRRect(
  //                                         borderRadius:
  //                                             BorderRadius.circular(10),
  //                                         child: CachedNetworkImage(
  //                                           imageUrl: url,
  //                                           fit: BoxFit.fill,
  //                                           placeholder: (context, url) =>
  //                                               const Center(
  //                                             child:
  //                                                 CircularProgressIndicator(),
  //                                           ),
  //                                           errorWidget: (context, url, error) {
  //                                             WidgetsBinding.instance
  //                                                 .addPostFrameCallback((_) {
  //                                               setState(() {
  //                                                 isimagethere = false;
  //                                               });
  //                                             });
  //                                             return const Center(
  //                                               child: Icon(
  //                                                 Icons.error,
  //                                                 color: Colors.red,
  //                                                 size: 50,
  //                                               ),
  //                                             );
  //                                           },
  //                                           imageBuilder:
  //                                               (context, imageProvider) {
  //                                             WidgetsBinding.instance
  //                                                 .addPostFrameCallback((_) {
  //                                               setState(() {
  //                                                 isimagethere = true;
  //                                               });
  //                                             });
  //                                             return Image(
  //                                               image: imageProvider,
  //                                               fit: BoxFit.fill,
  //                                             );
  //                                           },
  //                                         ),
  //                                       ),
  //                                       Center(
  //                                         child: Text(
  //                                           isimagethere
  //                                               ? Provider.of<LanguageProvider>(
  //                                                           context)
  //                                                       .isTamil
  //                                                   ? "தட்டவும்!"
  //                                                   : "Tap!"
  //                                               : '',
  //                                           style: TextStyle(
  //                                             fontSize: 17,
  //                                             fontWeight: FontWeight.bold,
  //                                             color: Colors.grey[300],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ));
  //                         }).toList(),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 50,
  //                       width: 300,
  //                       child: ElevatedButton(
  //                         onPressed: () {
  //                           String specificArea = reports[mainAreaIndex]
  //                                   .specificAreas?[specificAreaIndex]
  //                                   .specificArea ??
  //                               'No data';
  //                           String reportObservation = reports[mainAreaIndex]
  //                                   .specificAreas?[specificAreaIndex]
  //                                   .reportObservation ??
  //                               'No data';
  //                           String auditdate = reports[mainAreaIndex]
  //                                   .specificAreas?[specificAreaIndex]
  //                                   .auditDate ??
  //                               'No data';
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => CampusProgressEdit(
  //                                 taskid: taskid,
  //                                 mainArea: mainArea,
  //                                 specificArea: specificArea,
  //                                 reportObservation: reportObservation,
  //                                 auditDate: auditdate,
  //                                 month: month,
  //                                 weeknumber: selectedWeek,
  //                                 year: year,
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(20.0),
  //                           ),
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 50, vertical: 15),
  //                           backgroundColor: Colors.black,
  //                         ),
  //                         child: Text(
  //                           Provider.of<LanguageProvider>(context).isTamil
  //                               ? "உருவாக்கு"
  //                               : 'CREATE CAMPUS ID',
  //                           style: const TextStyle(
  //                             fontSize: 14,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget imageDialog(path, context) {
  //   return InteractiveViewer(
  //     child: Stack(
  //       children: [
  //         Dialog(
  //           elevation: 0,
  //           child: Builder(
  //             builder: (context) {
  //               var width = MediaQuery.of(context).size.width;
  //               return SizedBox(
  //                 width: width,
  //                 height: 500,
  //                 child: InteractiveViewer(
  //                   child: Image.network(
  //                     '$path',
  //                     fit: BoxFit.fill,
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //         Positioned(
  //           top: 0,
  //           right: 0,
  //           child: GestureDetector(
  //             onTap: () => Navigator.of(context).pop(),
  //             child: const Icon(
  //               Icons.cancel_outlined,
  //               color: Colors.white,
  //               size: 40,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showImageDialog(
    BuildContext context,
    String imageUrls,
    String mainArea,
    String taskid,
    int mainAreaIndex,
    int specificAreaIndex,
    List<NewWeeklyReport> reports,
  ) {
    const String baseUrl = '${ApiEndPoints.baseUrl}/';
    List<String> urls = imageUrls.split(',').map((url) {
      String formattedUrl =
          baseUrl + url.trim().replaceAll('\\', '/').replaceAll(' ', '%20');
      return formattedUrl;
    }).toList();

    PageController pageController = PageController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: SizedBox(
            height: 350,
            width: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: urls.length,
                        itemBuilder: (context, index) {
                          String url = urls[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => imageDialog(url, context),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: CachedNetworkImage(
                                    imageUrl: url,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SmoothPageIndicator(
                      controller: pageController,
                      count: urls.length,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.black,
                        dotColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          String specificArea = reports[mainAreaIndex]
                                  .specificAreas?[specificAreaIndex]
                                  .specificArea ??
                              'No data';
                          String reportObservation = reports[mainAreaIndex]
                                  .specificAreas?[specificAreaIndex]
                                  .reportObservation ??
                              'No data';
                          String auditdate = reports[mainAreaIndex]
                                  .specificAreas?[specificAreaIndex]
                                  .auditDate ??
                              'No data';

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CampusProgressEdit(
                                taskid: taskid,
                                mainArea: mainArea,
                                specificArea: specificArea,
                                reportObservation: reportObservation,
                                auditDate: auditdate,
                                month: month,
                                weeknumber: selectedWeek,
                                year: year,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'CREATE CAMPUS ID',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget imageDialog(String url, BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ),
          ),
          TextButton(
            // style: ButtonStyle(),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == MenuItems.selectWeek) {
      _pickWeek();
    } else if (choice == MenuItems.download) {
      fetchPDF();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey[200],
        appBar: AppBar(
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
          actionsIconTheme: const IconThemeData(
            size: 30,
          ),
          titleSpacing: 0,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          title: Text(
            Provider.of<LanguageProvider>(context).isTamil
                ? "வாராந்திர அறிக்கைகள்"
                : "Weekly Reports",
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize:
                  Provider.of<LanguageProvider>(context).isTamil ? 20 : 27,
              fontWeight: FontWeight.w500,
            ),
          ),
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
                  source: ReportDataSource(
                    context: context,
                    reports: reports,
                    onShowImageDialog: _showImageDialog,
                  ),
                  columnWidthMode: ColumnWidthMode.auto,
                  headerRowHeight: 100.0, // Set the header row height to 150.0
                  gridLinesVisibility: GridLinesVisibility.vertical,
                  headerGridLinesVisibility: GridLinesVisibility.vertical,
                  // onQueryRowHeight: (details) {
                  //   // Calculate and return the row height
                  //   return details.getIntrinsicRowHeight(
                  //     details.rowIndex,
                  //   );
                  // },
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
                          'Observation',
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
                      columnName: 'Remarks',
                      label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Remarks',
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
                      width: 120.0,
                      columnName: 'Images',
                      label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Images',
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
              ));
  }
}

class ReportDataSource extends DataGridSource {
  final BuildContext context;
  final List<NewWeeklyReport> reports;
  final Function(
    BuildContext,
    String,
    String,
    String,
    int,
    int,
    List<NewWeeklyReport>,
  ) onShowImageDialog;

  ReportDataSource({
    required this.context,
    required this.reports,
    required this.onShowImageDialog,
  }) {
    dataGridRows = reports
        .expand((report) => report.specificAreas!.map((area) {
              // Format the audit date to YYYY-MM-DD
              String formattedDate = "No data available";
              if (area.auditDate != null && area.auditDate!.isNotEmpty) {
                DateTime parsedDate = DateTime.parse(area.auditDate!);
                formattedDate =
                    "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
              }

              return DataGridRow(
                cells: [
                  DataGridCell<String>(
                      columnName: 'Main Area',
                      value: report.mainArea ?? "No data available"),
                  DataGridCell<String>(
                      columnName: 'Task ID',
                      value: report.taskId ?? "No data available"),
                  DataGridCell<String>(
                      columnName: 'Specific Area',
                      value: area.specificArea ?? "No data available"),
                  DataGridCell<String>(
                      columnName: 'Audit Date', value: formattedDate),
                  DataGridCell<String>(
                      columnName: 'Observation',
                      value: area.reportObservation ?? "No data available"),
                  DataGridCell<String>(
                      columnName: 'Remarks',
                      value: area.remarks ?? "No data available"),
                  DataGridCell<String>(
                      columnName: 'Images', value: area.images ?? "No images"),
                ],
              );
            }))
        .toList();
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
            padding: cell.columnName == 'Images' && cell.value != "No images"
                ? const EdgeInsets.symmetric(vertical: 0, horizontal: 5)
                : const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            alignment: Alignment.centerLeft,
            child: cell.columnName == 'Images'
                ? _buildImagesCell(
                    cell.value,
                    rowIndex,
                    row,
                  )
                : Text(
                    cell.value.toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
          ),
      ],
    );
  }

  Widget _buildImagesCell(String imagesValue, int rowIndex, DataGridRow row) {
    // Get the 'Remarks' value for the current row
    String remarksValue =
        row.getCells().firstWhere((cell) => cell.columnName == 'Remarks').value;

    // Check if the remarks contain "bad", ignoring case and whitespace
    bool containsBad = remarksValue
        .split(',')
        .map((item) => item.trim().toLowerCase())
        .contains('bad');

    // Define the button text and the logic for which button to display
    String buttonText;

    // Handle cells with data (Images available)
    if (imagesValue != "No images") {
      buttonText = 'View Images';
    }
    // Handle cells without data but with "bad" in remarks
    else if (containsBad) {
      buttonText = 'Create Id';
    }
    // Handle cells without data and no "bad" in remarks
    else {
      buttonText = 'No images';
    }

    // Print statements for debugging
    print('Images Value: $imagesValue');
    print('Contains "bad": $containsBad');
    print('Button Text: $buttonText');

    // If a button should be shown
    if (buttonText == 'View Images') {
      // Calculate indices
      int mainAreaIndex = rowIndex ~/ reports.first.specificAreas!.length;
      int specificAreaIndex = rowIndex % reports.first.specificAreas!.length;

      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 120.0, // Set a maximum width for the button
        ),
        child: TextButton(
          onPressed: () {
            onShowImageDialog(
              context,
              imagesValue,
              reports[mainAreaIndex].mainArea ?? 'Unknown',
              reports[mainAreaIndex].taskId ?? 'Unknown',
              mainAreaIndex,
              specificAreaIndex,
              reports,
            );
          },
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.blue,
              // fontSize: 16,
            ),
          ),
        ),
      );
    } else if (containsBad) {
      // Calculate indices
      int mainAreaIndex = rowIndex ~/ reports.first.specificAreas!.length;
      int specificAreaIndex = rowIndex % reports.first.specificAreas!.length;

      return GestureDetector(
        onTap: () {
          onShowImageDialog(
            context,
            imagesValue,
            reports[mainAreaIndex].mainArea ?? 'Unknown',
            reports[mainAreaIndex].taskId ?? 'Unknown',
            mainAreaIndex,
            specificAreaIndex,
            reports,
          );
        },
        child: Container(
          child: Text(
            "Create Id",
            style: const TextStyle(
              color: Colors.blue,
              // fontSize: 16,
            ),
          ),
        ),
      );

      // ConstrainedBox(
      //   constraints: const BoxConstraints(
      //     maxWidth: 120.0, // Set a maximum width for the button
      //   ),
      //   child: TextButton(
      //     onPressed: () {
      //       onShowImageDialog(
      //         context,
      //         imagesValue,
      //         reports[mainAreaIndex].mainArea ?? 'Unknown',
      //         reports[mainAreaIndex].taskId ?? 'Unknown',
      //         mainAreaIndex,
      //         specificAreaIndex,
      //         reports,
      //       );
      //     },
      //     child: Text(
      //       buttonText,
      //       style: const TextStyle(
      //         color: Colors.blue,
      //         // fontSize: 16,
      //       ),
      //     ),
      //   ),
      // );
    } else {
      // Plain text for "No images" without "bad" in remarks
      return Text(
        buttonText,
        style: const TextStyle(
          // fontSize: 16, // Adjust the font size
          color: Colors.black, // Ensure plain text color is visible
        ),
      );
    }
  }
}
      // body: SingleChildScrollView(
      //   scrollDirection: Axis.vertical,
      //   child: Stack(
      //     children: [
      //       SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: Padding(
      //           padding: const EdgeInsets.only(
      //             left: 130.0,
      //           ),
      //           child: Column(
      //             children: [
      //               Row(
      //                 children: [
      //                   _buildHeaderCell(
      //                       Provider.of<LanguageProvider>(context).isTamil
      //                           ? "குறிப்பிட்ட பகுதிகள்"
      //                           : "Specific Areas",
      //                       200),
      //                   _buildHeaderCell(
      //                       Provider.of<LanguageProvider>(context).isTamil
      //                           ? "தணிக்கை தேதிகள்"
      //                           : "Audit Dates",
      //                       160),
      //                   _buildHeaderCell(
      //                       Provider.of<LanguageProvider>(context).isTamil
      //                           ? "அவதானிப்பு அறிக்கை"
      //                           : "Report Observation",
      //                       450),
      //                   _buildHeaderCell(
      //                       Provider.of<LanguageProvider>(context).isTamil
      //                           ? "கருத்துக்கள்"
      //                           : "Remarks",
      //                       300),
      //                   _buildHeaderCell(
      //                       Provider.of<LanguageProvider>(context).isTamil
      //                           ? "படங்கள்"
      //                           : "Images",
      //                       Provider.of<LanguageProvider>(context).isTamil
      //                           ? 240
      //                           : 220),
      //                 ],
      //               ),
      //               ...List.generate(reports.length, (index) {
      //                 return Row(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     _buildNestedDataCell(
      //                         reports[index]
      //                                 .specificAreas
      //                                 ?.map((area) =>
      //                                     area.specificArea ?? 'No data')
      //                                 .toList() ??
      //                             ['No data'],
      //                         200,
      //                         200,
      //                         false,
      //                         false,
      //                         false,
      //                         null,
      //                         index, // Pass the index here
      //                         reports[index].mainArea ??
      //                             'No data', // Pass mainArea
      //                         reports[index].taskId ??
      //                             'No data', // Pass mainArea
      //                         reports),
      //                     _buildNestedDataCell(
      //                         reports[index]
      //                                 .specificAreas
      //                                 ?.map((area) =>
      //                                     area.auditDate ?? 'No data')
      //                                 .toList() ??
      //                             ['No data'],
      //                         160,
      //                         200,
      //                         false,
      //                         true,
      //                         false,
      //                         null,
      //                         index, // Pass the index here
      //                         reports[index].mainArea ??
      //                             'No data', // Pass mainArea
      //                         reports[index].taskId ?? 'No data',
      //                         reports),
      //                     _buildNestedDataCell(
      //                         reports[index]
      //                                 .specificAreas
      //                                 ?.map((area) =>
      //                                     area.reportObservation ?? 'No data')
      //                                 .toList() ??
      //                             ['No data'],
      //                         450,
      //                         200,
      //                         false,
      //                         false,
      //                         false,
      //                         null,
      //                         index, // Pass the index here
      //                         reports[index].mainArea ??
      //                             'No data', // Pass mainArea
      //                         reports[index].taskId ?? 'No data',
      //                         reports),
      //                     _buildNestedDataCell(
      //                         reports[index]
      //                                 .specificAreas
      //                                 ?.map((area) => area.remarks)
      //                                 .toList() ??
      //                             ['No data'],
      //                         300,
      //                         200,
      //                         false,
      //                         false,
      //                         true,
      //                         null,
      //                         index, // Pass the index here
      //                         reports[index].mainArea ??
      //                             'No data', // Pass mainArea
      //                         reports[index].taskId ?? 'No data',
      //                         reports),
      //                     _buildNestedDataCell(
      //                         reports[index]
      //                                 .specificAreas
      //                                 ?.map((area) => area.images)
      //                                 .toList() ??
      //                             ['No data'],
      //                         Provider.of<LanguageProvider>(context).isTamil
      //                             ? 240
      //                             : 220,
      //                         200,
      //                         true,
      //                         false,
      //                         false,
      //                         reports[index]
      //                                 .specificAreas
      //                                 ?.map((area) => area.images)
      //                                 .toList() ??
      //                             ['No data'],
      //                         index, // Pass the index here
      //                         reports[index].mainArea ??
      //                             'No data', // Pass mainArea
      //                         reports[index].taskId ?? 'No data',
      //                         reports),
      //                   ],
      //                 );
      //               }),
      //             ],
      //           ),
      //         ),
      //       ),
      //       Positioned(
      //         // left: 10,
      //         top: 0,
      //         bottom: 0,
      //         child: Container(
      //           width: 130,
      //           color: Colors.grey[200],
      //           child: Padding(
      //             padding: const EdgeInsets.only(right: 0.0),
      //             child: Column(
      //               children: [
      //                 _buildHeaderCell(
      //                     Provider.of<LanguageProvider>(context).isTamil
      //                         ? "தணிக்கை பகுதி"
      //                         : "Audit Area",
      //                     200),
      //                 ...List.generate(reports.length, (index) {
      //                   return _buildDataCell(
      //                       reports[index].mainArea ?? 'No data', 150, 200);
      //                 }),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),