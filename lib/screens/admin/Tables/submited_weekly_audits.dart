import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
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
import 'package:get_storage/get_storage.dart';
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
import 'dart:ui' as ui;

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
  final box = GetStorage();

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
    try {
      final response = await http.get(Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.getweeklyreports}/$selectedWeek/$month/$year',
      ));

      if (response.statusCode == 200) {
        print(response.body);
        if (mounted) {
          setState(() {
            reports = (jsonDecode(response.body) as List)
                .map((json) => NewWeeklyReport.fromJson(json))
                .toList();
            auditsDataJson = reports.map((report) => report.toJson()).toList();
            // Calculating the total valid observations
            totalObservations = reports.fold(
                0, (sum, report) => sum + report.totalValidObservationCount);

            totalRemarks = reports.fold(
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

  int _getWeekOfMonth(DateTime date) {
    // Find the first day of the month
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    // Calculate the week number of the month
    int weekNumber = ((date.day + firstDayOfMonth.weekday - 1) / 7).ceil();
    return weekNumber;
  }

  bool isfetching = false;
  Future<void> fetchPDF() async {
    setState(() {
      isfetching = true;
    });
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
    setState(() {
      isfetching = false;
    });
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      print('Error opening PDF: ${result.message}');
    }
  }

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
                    ),
                  );
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
            fontSize: Provider.of<LanguageProvider>(context).isTamil ? 17 : 25,
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
          : isfetching
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    sfdatagridwidget(),
                    BackdropFilter(
                      filter: ui.ImageFilter.blur(
                        sigmaX: 8.0,
                        sigmaY: 8.0,
                      ),
                      child: Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: SpinKitThreeBounce(
                            color: Color.fromARGB(255, 97, 81, 188),
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : sfdatagridwidget(),
    );
  }

  Widget sfdatagridwidget() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
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

        // onQueryRowHeight: (RowHeightDetails details) {
        //   if (details.rowIndex== 2) {
        //     // Return a specific height for the header row
        //     return 100.0;
        //   } else {
        //     // Calculate and return the intrinsic height for other rows
        //     return details.getIntrinsicRowHeight(details.rowIndex);
        //   }
        // },
        columns: <GridColumn>[
          GridColumn(
            columnName: 'Main Area',
            label: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "வாராந்திர அறிக்கைகள்"
                    : 'Main Area',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 15 : 17,
                  color: Colors.white,
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ),
          GridColumn(
            columnName: 'Task ID',
            label: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "பணி ஐடி"
                    : 'Task ID',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 15 : 17,
                  color: Colors.white,
                ),
                overflow: TextOverflow.visible,
                // softWrap: true,
              ),
            ),
          ),
          GridColumn(
            columnName: 'Specific Area',
            label: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "பகுதி"
                    : 'Specific Area',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 15 : 17,
                  color: Colors.white,
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ),
          GridColumn(
            columnName: 'Audit Date',
            label: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "தேதி"
                    : 'Audit Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 15 : 17,
                  color: Colors.white,
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ),
          GridColumn(
            columnName: 'Observation',
            label: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "கவனிப்புகள்"
                    : 'Observation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 15 : 17,
                  color: Colors.white,
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ),
          GridColumn(
            columnName: 'Remarks',
            label: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "கருத்துக்கள்"
                    : 'Remarks',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 15 : 17,
                  color: Colors.white,
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ),
          GridColumn(
            width: 150.0,
            columnName: 'Images',
            label: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "படங்கள்"
                    : 'Images',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 15 : 17,
                  color: Colors.white,
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
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
                : FittedBox(
                    child: Text(
                      cell.value.toString(),
                      overflow: TextOverflow.visible,
                      style: const TextStyle(fontSize: 15),
                    ),
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
    } else {
      // Plain text for "No images" without "bad" in remarks
      return Text(
        buttonText,
        overflow: TextOverflow.clip,
        style: const TextStyle(
          color: Colors.black, // Ensure plain text color is visible
        ),
      );
    }
  }
}
