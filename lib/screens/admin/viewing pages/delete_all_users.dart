import 'dart:convert';
import 'package:auditfitnesstest/models/user%20data/all_users_model.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAllUsers extends StatefulWidget {
  const DeleteAllUsers({super.key});
  @override
  _DeleteAllUsersState createState() => _DeleteAllUsersState();
}

class _DeleteAllUsersState extends State<DeleteAllUsers> {
  Future<List<AllUsersModel>> fetchUsers() async {
    final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.userdata));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => AllUsersModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> updateUser(AllUsersModel user) async {
    final response = await http.put(
      Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.userdata}/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
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
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.userdata}/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  late Future<List<AllUsersModel>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 100,
        titleSpacing: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.purple[900],
        title: Text(
          overflow: TextOverflow.visible,
          Provider.of<LanguageProvider>(context).isTamil
              ? "பயனர்களை நீக்கு"
              : "Delete Users",
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<AllUsersModel>>(
            future: futureUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users found'));
              } else {
                List<AllUsersModel> users = snapshot.data!;
                List<AllUsersModel> userRoles1 =
                    users.where((user) => user.role == 1).toList();
                List<AllUsersModel> userRoles2 =
                    users.where((user) => user.role == 2).toList();
                List<AllUsersModel> userRoles3 =
                    users.where((user) => user.role == 3).toList();

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildRoleTile(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "பயனர்கள்"
                              : 'Users',
                          userRoles2),
                      _buildRoleTile(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "நிர்வாகிகள்"
                              : 'Admins',
                          userRoles1),
                      _buildRoleTile(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "வளாகம்"
                              : 'Campus',
                          userRoles3),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTile(String title, List<AllUsersModel> users) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 30.0,
                horizontalMargin: 30.0,
                columns: [
                  DataColumn(
                      label: Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "ஐடி"
                              : 'ID',
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "பயனர் பெயர்"
                              : 'Username',
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "முதல் பெயர்"
                              : 'First Name',
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "கடைசி பெயர்"
                              : 'Last Name',
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "தொலைபேசி எண்"
                              : 'Phone Number',
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "பணியாளர் ஐடி"
                              : 'Staff Id',
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "செயல்கள்"
                              : 'Actions-Edit',
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "செயல்கள்"
                              : 'Actions-Delete',
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: users
                    .map(
                      (user) => DataRow(cells: [
                        DataCell(Text(user.id.toString())),
                        DataCell(Text(user.username ?? '')),
                        DataCell(Text(user.firstName ?? '')),
                        DataCell(Text(user.lastName ?? '')),
                        DataCell(Text(user.phoneNumber?.toString() ?? '')),
                        DataCell(Text(user.staffId ?? '')),
                        DataCell(const Icon(Icons.edit), onTap: () {
                          _editUserDialog(user);
                        }),
                        DataCell(
                          const Icon(Icons.delete, color: Colors.red),
                          onTap: () {
                            _confirmDelete(user);
                          },
                        ),
                      ]),
                    )
                    .toList(),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(AllUsersModel user) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Provider.of<LanguageProvider>(context).isTamil
              ? "நீக்குதலை உறுதிப்படுத்தவும்"
              : 'Confirm Deletion'),
          content: Text(Provider.of<LanguageProvider>(context).isTamil
              ? "இந்தப் பயனரை நிச்சயமாக நீக்க விரும்புகிறீர்களா?"
              : 'Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(Provider.of<LanguageProvider>(context).isTamil
                  ? "ரத்து செய்"
                  : 'Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(Provider.of<LanguageProvider>(context).isTamil
                  ? "அழி"
                  : 'Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await deleteUser((user.id!));
      setState(() {
        futureUsers = fetchUsers();
      });
    }
  }

  Future<void> _editUserDialog(AllUsersModel user) async {
    TextEditingController usernameController =
        TextEditingController(text: user.username);
    TextEditingController firstNameController =
        TextEditingController(text: user.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: user.lastName);
    TextEditingController phoneNumberController =
        TextEditingController(text: user.phoneNumber?.toString());
    TextEditingController staffIdController =
        TextEditingController(text: user.staffId);

    final editedUser = await showDialog<AllUsersModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Provider.of<LanguageProvider>(context).isTamil
              ? "பயனர்களைத் திருத்தவும்"
              : 'Edit User'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      labelText: Provider.of<LanguageProvider>(context).isTamil
                          ? "பயனர் பெயர்"
                          : 'Username'),
                ),
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                      labelText: Provider.of<LanguageProvider>(context).isTamil
                          ? "முதல் பெயர்"
                          : 'First Name'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                      labelText: Provider.of<LanguageProvider>(context).isTamil
                          ? "கடைசி பெயர்"
                          : 'Last Name'),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                      labelText: Provider.of<LanguageProvider>(context).isTamil
                          ? "தொலைபேசி எண்"
                          : 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: staffIdController,
                  decoration: InputDecoration(
                      labelText: Provider.of<LanguageProvider>(context).isTamil
                          ? "பணியாளர் ஐடி"
                          : 'Staff Id'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                user.username = usernameController.text;
                user.firstName = firstNameController.text;
                user.lastName = lastNameController.text;
                user.phoneNumber = int.parse(phoneNumberController.text);
                user.staffId = staffIdController.text;
                Navigator.of(context).pop(user);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (editedUser != null) {
      await updateUser(editedUser);
      setState(() {
        futureUsers = fetchUsers();
      });
    }
  }
}
