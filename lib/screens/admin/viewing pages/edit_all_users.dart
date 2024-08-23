// // import 'dart:convert';
// // import 'package:auditfitnesstest/models/all_users_model.dart';
// // import 'package:auditfitnesstest/models/locale_provider.dart';
// // import 'package:auditfitnesstest/utils/apiendpoints.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // class EditAllUsers extends StatefulWidget {
// //   const EditAllUsers({super.key});
// //   @override
// //   _EditAllUsersState createState() => _EditAllUsersState();
// // }

// // class _EditAllUsersState extends State<EditAllUsers> {
// //   Future<List<AllUsersModel>> fetchUsers() async {
// //     final response = await http.get(
// //         Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.userdata));

// //     if (response.statusCode == 200) {
// //       List<dynamic> jsonData = json.decode(response.body);
// //       return jsonData.map((json) => AllUsersModel.fromJson(json)).toList();
// //     } else {
// //       throw Exception('Failed to load users');
// //     }
// //   }

// //   late Future<List<AllUsersModel>> futureUsers;

// //   @override
// //   void initState() {
// //     super.initState();
// //     futureUsers = fetchUsers();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey[200],
// //       appBar: AppBar(
// //         toolbarHeight: 100,
// //         titleSpacing: 0,
// //         iconTheme: const IconThemeData(
// //           color: Colors.white,
// //         ),
// //         backgroundColor: Colors.purple[900],
// //         title: Text(
// //           overflow: TextOverflow.visible,
// //           Provider.of<LanguageProvider>(context).isTamil
// //               ? "நிர்வாக டாஷ்போர்டு"
// //               : "Edit All Users",
// //           style: GoogleFonts.manrope(
// //             color: Colors.white,
// //             fontSize: 20,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ),
// //       body: FutureBuilder<List<AllUsersModel>>(
// //         future: futureUsers,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return const Center(child: Text('No users found'));
// //           } else {
// //             List<AllUsersModel> users = snapshot.data!;
// //             List<AllUsersModel> userRoles1 =
// //                 users.where((user) => user.role == 1).toList();
// //             List<AllUsersModel> userRoles2 =
// //                 users.where((user) => user.role == 2).toList();
// //             List<AllUsersModel> userRoles3 =
// //                 users.where((user) => user.role == 3).toList();

// //             return SingleChildScrollView(
// //               child: Column(
// //                 children: [
// //                   _buildRoleTile('Users', userRoles2),
// //                   _buildRoleTile('Admins', userRoles1),
// //                   _buildRoleTile('Campus', userRoles3),
// //                 ],
// //               ),
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildRoleTile(String title, List<AllUsersModel> users) {
// //     return Card(
// //       margin: const EdgeInsets.all(8.0),
// //       child: ExpansionTile(
// //         title: Text(
// //           title,
// //           style: const TextStyle(
// //             fontWeight: FontWeight.bold,
// //             fontSize: 18.0,
// //           ),
// //         ),
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: SingleChildScrollView(
// //               scrollDirection: Axis.horizontal,
// //               child: DataTable(
// //                 columnSpacing: 30.0,
// //                 horizontalMargin: 30.0,
// //                 columns: const [
// //                   DataColumn(
// //                       label: Text('ID',
// //                           style: TextStyle(fontWeight: FontWeight.bold))),
// //                   DataColumn(
// //                       label: Text('Username',
// //                           style: TextStyle(fontWeight: FontWeight.bold))),
// //                   DataColumn(
// //                       label: Text('First Name',
// //                           style: TextStyle(fontWeight: FontWeight.bold))),
// //                   DataColumn(
// //                       label: Text('Last Name',
// //                           style: TextStyle(fontWeight: FontWeight.bold))),
// //                   DataColumn(
// //                       label: Text('Phone Number',
// //                           style: TextStyle(fontWeight: FontWeight.bold))),
// //                   DataColumn(
// //                       label: Text('Staff Id',
// //                           style: TextStyle(fontWeight: FontWeight.bold))),
// //                 ],
// //                 rows: users
// //                     .map(
// //                       (user) => DataRow(cells: [
// //                         DataCell(Text(user.id.toString())),
// //                         DataCell(Text(user.username ?? '')),
// //                         DataCell(Text(user.firstName ?? '')),
// //                         DataCell(Text(user.lastName ?? '')),
// //                         DataCell(Text(user.phoneNumber?.toString() ?? '')),
// //                         DataCell(
// //                           Text(user.staffId ?? ''),
// //                           showEditIcon: true,
// //                           onTap: (){

// //                           }
// //                         ),
// //                       ]),
// //                     )
// //                     .toList(),
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.grey),
// //                   borderRadius: BorderRadius.circular(8.0),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'package:auditfitnesstest/models/all_users_model.dart';
// import 'package:auditfitnesstest/models/locale_provider.dart';
// import 'package:auditfitnesstest/utils/apiendpoints.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class EditAllUsers extends StatefulWidget {
//   const EditAllUsers({super.key});
//   @override
//   _EditAllUsersState createState() => _EditAllUsersState();
// }

// class _EditAllUsersState extends State<EditAllUsers> {
//   Future<List<AllUsersModel>> fetchUsers() async {
//     final response = await http.get(
//         Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.userdata));

//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       return jsonData.map((json) => AllUsersModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load users');
//     }
//   }

//   Future<void> updateUser(AllUsersModel user) async {
//     final response = await http.put(
//       Uri.parse(
//           '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.userdata}/${user.id}'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(user.toJson()),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to update user');
//     }
//   }

//   late Future<List<AllUsersModel>> futureUsers;

//   @override
//   void initState() {
//     super.initState();
//     futureUsers = fetchUsers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         toolbarHeight: 100,
//         titleSpacing: 0,
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         backgroundColor: Colors.purple[900],
//         title: Text(
//           overflow: TextOverflow.visible,
//           Provider.of<LanguageProvider>(context).isTamil
//               ? "அனைத்து பயனர்களையும் திருத்தவும்"
//               : "Edit All Users",
//           style: GoogleFonts.manrope(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: FutureBuilder<List<AllUsersModel>>(
//         future: futureUsers,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No users found'));
//           } else {
//             List<AllUsersModel> users = snapshot.data!;
//             List<AllUsersModel> userRoles1 =
//                 users.where((user) => user.role == 1).toList();
//             List<AllUsersModel> userRoles2 =
//                 users.where((user) => user.role == 2).toList();
//             List<AllUsersModel> userRoles3 =
//                 users.where((user) => user.role == 3).toList();

//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildRoleTile(
//                       Provider.of<LanguageProvider>(context).isTamil
//                           ? "பயனர்கள்"
//                           : 'Users',
//                       userRoles2),
//                   _buildRoleTile(
//                       Provider.of<LanguageProvider>(context).isTamil
//                           ? "நிர்வாகிகள்"
//                           : 'Admins',
//                       userRoles1),
//                   _buildRoleTile(
//                       Provider.of<LanguageProvider>(context).isTamil
//                           ? "வளாகம்"
//                           : 'Campus',
//                       userRoles3),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildRoleTile(String title, List<AllUsersModel> users) {
//     return Card(
//       margin: const EdgeInsets.all(8.0),
//       child: ExpansionTile(
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18.0,
//           ),
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columnSpacing: 50.0,
//                 // horizontalMargin: 30.0,
//                 columns: [
//                   DataColumn(
//                       label: Text(
//                           Provider.of<LanguageProvider>(context).isTamil
//                               ? "ஐடி"
//                               : 'ID',
//                           style: const TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text(
//                           Provider.of<LanguageProvider>(context).isTamil
//                               ? "பயனர் பெயர்"
//                               : 'Username',
//                           style: const TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text(
//                           Provider.of<LanguageProvider>(context).isTamil
//                               ? "முதல் பெயர்"
//                               : 'First Name',
//                           style: const TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text(
//                           Provider.of<LanguageProvider>(context).isTamil
//                               ? "கடைசி பெயர்"
//                               : 'Last Name',
//                           style: const TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text(
//                           Provider.of<LanguageProvider>(context).isTamil
//                               ? "தொலைபேசி எண்"
//                               : 'Phone Number',
//                           style: const TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text(
//                           Provider.of<LanguageProvider>(context).isTamil
//                               ? "பணியாளர் ஐடி"
//                               : 'Staff Id',
//                           style: const TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text(
//                           Provider.of<LanguageProvider>(context).isTamil
//                               ? "செயல்கள்"
//                               : 'Actions',
//                           style: const TextStyle(fontWeight: FontWeight.bold))),
//                 ],
//                 rows: users
//                     .map(
//                       (user) => DataRow(cells: [
//                         DataCell(Text(user.id.toString())),
//                         DataCell(Text(user.username ?? '')),
//                         DataCell(Text(user.firstName ?? '')),
//                         DataCell(Text(user.lastName ?? '')),
//                         DataCell(Text(user.phoneNumber?.toString() ?? '')),
//                         DataCell(Text(user.staffId ?? '')),
//                         DataCell(const Icon(Icons.edit), onTap: () {
//                           _editUserDialog(user);
//                         })
//                       ]),
//                     )
//                     .toList(),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _editUserDialog(AllUsersModel user) async {
//     TextEditingController usernameController =
//         TextEditingController(text: user.username);
//     TextEditingController firstNameController =
//         TextEditingController(text: user.firstName);
//     TextEditingController lastNameController =
//         TextEditingController(text: user.lastName);
//     TextEditingController phoneNumberController =
//         TextEditingController(text: user.phoneNumber?.toString());
//     TextEditingController staffIdController =
//         TextEditingController(text: user.staffId);

//     final editedUser = await showDialog<AllUsersModel>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(Provider.of<LanguageProvider>(context).isTamil
//               ? "பயனர்களைத் திருத்தவும்"
//               : 'Edit User'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: usernameController,
//                   decoration: InputDecoration(
//                       labelText: Provider.of<LanguageProvider>(context).isTamil
//                           ? "பயனர் பெயர்"
//                           : 'Username'),
//                 ),
//                 TextField(
//                   controller: firstNameController,
//                   decoration: InputDecoration(
//                       labelText: Provider.of<LanguageProvider>(context).isTamil
//                           ? "முதல் பெயர்"
//                           : 'First Name'),
//                 ),
//                 TextField(
//                   controller: lastNameController,
//                   decoration: InputDecoration(
//                       labelText: Provider.of<LanguageProvider>(context).isTamil
//                           ? "கடைசி பெயர்"
//                           : 'Last Name'),
//                 ),
//                 TextField(
//                   controller: phoneNumberController,
//                   decoration: InputDecoration(
//                       labelText: Provider.of<LanguageProvider>(context).isTamil
//                           ? "தொலைபேசி எண்"
//                           : 'Phone Number'),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 TextField(
//                   controller: staffIdController,
//                   decoration: InputDecoration(
//                       labelText: Provider.of<LanguageProvider>(context).isTamil
//                           ? "பணியாளர் ஐடி"
//                           : 'Staff Id'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 user.username = usernameController.text;
//                 user.firstName = firstNameController.text;
//                 user.lastName = lastNameController.text;
//                 user.phoneNumber = int.parse(phoneNumberController.text);
//                 user.staffId = staffIdController.text;
//                 Navigator.of(context).pop(user);
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );

//     if (editedUser != null) {
//       await updateUser(editedUser);
//       setState(() {
//         futureUsers = fetchUsers();
//       });
//     }
//   }
// }
