// // import 'dart:convert';
// import 'package:auditfitnesstest/models/daily_task_id_model.dart';
// import 'package:auditfitnesstest/screens/user/Monthly-Audit/monthly_audit_submit_page.dart';
// // import 'package:auditfitnesstest/utils/apiendpoints.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// // import 'package:http/http.dart' as http;

// class MonthlyUserAuditListPage extends StatefulWidget {
//   const MonthlyUserAuditListPage({super.key});
//   @override
//   State<MonthlyUserAuditListPage> createState() =>
//       MonthlyUserAuditListPageState();
// }

// class MonthlyUserAuditListPageState extends State<MonthlyUserAuditListPage> {
//   final box = GetStorage();
//   @override
//   void initState() {
//     super.initState();
//     futureDailyTasks = fetchDailyTasks();
//   }

//   // Future<List<DailyTaskId>> fetchDailyTasks() async {
//   //   final response = await http.get(Uri.parse(
//   //       ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.showalldailyauditId));
//   //   if (response.statusCode == 200) {
//   //     List<dynamic> jsonData = json.decode(response.body);
//   //     List<DailyTaskId> dailyTasks =
//   //         jsonData.map((item) => DailyTaskId.fromJson(item)).toList();

//   //     String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   //     List<DailyTaskId> filteredTasks =
//   //         dailyTasks.where((task) => task.createdAt == currentDate).toList();

//   //     return filteredTasks;
//   //   } else {
//   //     throw Exception('Failed to load daily tasks');
//   //   }
//   // }

//   fetchDailyTasks() async {
//     // username = box.read('username');
//     // final response = await http.get(Uri.parse(
//     //     ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.showalldailyauditId));

//     // if (response.statusCode == 200) {
//     //   List<dynamic> jsonData = json.decode(response.body);
//     //   List<DailyTaskId> dailyTasks =
//     //       jsonData.map((item) => DailyTaskId.fromJson(item)).toList();

//     //   dailyTasks.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
//     //   // List<DailyTaskId> filteredTasks =
//     //   //     dailyTasks.where((task) => task.username == username).toList();

//     //   List<DailyTaskId> lastFiveTasks = dailyTasks.take(5).toList();
//     //   return lastFiveTasks;
//     // } else {
//     //   throw Exception('Failed to load daily tasks');
//     // }
//   }

//   late Future<List<DailyTaskId>> futureDailyTasks;
//   String username = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recent Daily Tasks'),
//       ),
//       body: Center(
//         child: FutureBuilder<List<DailyTaskId>>(
//           future: futureDailyTasks,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Text('No tasks found for today');
//             } else {
//               List<DailyTaskId> tasks = snapshot.data!;
//               return ListView.builder(
//                 itemCount: tasks.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               const MonthlyUserAuditSubmmitPage(),
//                           // DailyAuditAssignmentpage(
//                           //   dailyAuditId: tasks[index].taskId,
//                           //   dailyAuditdate: tasks[index].date,
//                           // ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       margin: const EdgeInsets.all(10.0),
//                       child: ListTile(
//                         title: Text(tasks[index].taskId ?? 'No Task ID'),
//                         subtitle: Text(tasks[index].date ?? 'No Date'),
//                         trailing:
//                             Text(tasks[index].createdAt ?? 'No Creation Time'),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
