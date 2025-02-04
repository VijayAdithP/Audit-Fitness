import 'package:auditfitnesstest/models/admin%20specific/weekly%20models/user_weekly_tasks_model.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LanguageProvider with ChangeNotifier {
  final box = GetStorage();
  bool _isTamil = false;

  bool get isTamil => _isTamil;

  LanguageProvider() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() async {
    _isTamil = box.read('isTamil') ?? false;
    notifyListeners();
  }

  void toggleLanguage() async {
    _isTamil = !_isTamil;

    box.write('isTamil', _isTamil);
    notifyListeners();
  }
}

// class WeeklyTasksProvider with ChangeNotifier {
//   final box = GetStorage();
//   int _weeklyTasksCount = 0;
//   Timer? _timer;

//   int get weeklyTasksCount => _weeklyTasksCount;

//   WeeklyTasksProvider() {
//     fetchWeeklyTasks();
//     _startFetching();
//   }

//   void _startFetching() {
//     _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
//       fetchWeeklyTasks();
//     });
//   }

//   Future<void> fetchWeeklyTasks() async {
//     final String? username = box.read('username');
//     try {
//       if (username == null) {
//         _weeklyTasksCount = 0;
//         notifyListeners();
//         return;
//       }

//       final response = await http.get(Uri.parse(
//           '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getweeklytaskper}/$username'));

//       if (response.statusCode == 200) {
//         List<dynamic> jsonData = json.decode(response.body);
//         List<UserWeeklyTasksModel> weeklyTasks = jsonData
//             .map((item) => UserWeeklyTasksModel.fromJson(item))
//             .toList();

//         weeklyTasks.sort((a, b) => b.assignedAt!.compareTo(a.assignedAt!));

//         _weeklyTasksCount = weeklyTasks.length;
//         notifyListeners();
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }

class WeeklyTasksProvider with ChangeNotifier {
  final box = GetStorage();
  int _weeklyTasksCount = 0;
  Timer? _timer;
  bool _isFetching = true;

  int get weeklyTasksCount => _weeklyTasksCount;
  bool get isFetching => _isFetching;

  WeeklyTasksProvider() {
    fetchWeeklyTasks();
    _startFetching();
  }

  void _startFetching() {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      print("in");
      fetchWeeklyTasks();
    });
  }

  void _stopFetching() {
    _timer?.cancel();
  }

  void toggleFetching() {
    if (_isFetching) {
      _stopFetching();
    } else {
      _startFetching();
    }
    _isFetching = !_isFetching;
    notifyListeners();
  }

  Future<void> fetchWeeklyTasks() async {
    final String? username = box.read('username');
    if (!_isFetching) return;

    try {
      final response = await http.get(
        Uri.parse(
            '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getweeklytaskper}/$username'),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<UserWeeklyTasksModel> weeklyTasks = jsonData
            .map((item) => UserWeeklyTasksModel.fromJson(item))
            .toList();

        weeklyTasks.sort((a, b) => b.assignedAt!.compareTo(a.assignedAt!));
        print(weeklyTasks);

        _weeklyTasksCount = weeklyTasks.length;
        notifyListeners();
      } else {
        print('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weekly tasks: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
