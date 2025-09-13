import 'dart:convert';
import 'package:auditfitnesstest/assets/colors.dart';
import 'package:auditfitnesstest/models/user%20data/all_users_model.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/bad_condition_user.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllUsers extends StatefulWidget {
  const ViewAllUsers({super.key});
  @override
  _ViewAllUsersState createState() => _ViewAllUsersState();
}

class _ViewAllUsersState extends State<ViewAllUsers> {
  Future<List<AllUsersModel>> fetchUsers() async {
    final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.userdata));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return jsonData.map((json) => AllUsersModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  bool isLoading = true;
  late Future<List<AllUsersModel>> futureUsers;
  int _currIndex = 0;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  Future<void> _onrefresh2() async {
    await Future.delayed(Duration(seconds: 1));

    try {
      futureUsers = fetchUsers();
      setState(() {});
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: lighterbackgroundblue,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: darkblue,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            toolbarHeight: 70,
            titleSpacing: 0,
            title: Text(
              Provider.of<LanguageProvider>(context).isTamil
                  ? "அனைத்து பயனர்கள்"
                  : "All users",
              style: TextStyle(
                color: darkblue,
                fontWeight: FontWeight.bold,
                fontSize:
                    Provider.of<LanguageProvider>(context).isTamil ? 18 : 21,
              ),
            ),
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: child.key == ValueKey('icon1')
                        ? Tween<double>(begin: 1, end: -1).animate(anim)
                        : Tween<double>(begin: -1, end: 1).animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: _currIndex == 0
                      ? Icon(
                          Icons.sync,
                          color: darkblue,
                          key: const ValueKey('icon1'),
                          size: 20,
                        )
                      : Icon(
                          Icons.sync,
                          color: darkblue,
                          key: const ValueKey('icon2'),
                          size: 20,
                        ),
                ),
                onPressed: () {
                  _onrefresh2();
                  setState(() {
                    _currIndex = _currIndex == 0 ? 1 : 0;
                  });
                },
              ),
              SizedBox(width: 16), // Add spacing between the icons and the edge
            ],
          ),
          body: isLoading
              ? const Center(
                  child: SpinKitThreeBounce(
                    color: Color.fromARGB(255, 97, 81, 188),
                    size: 30,
                  ),
                )
              : Column(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.only(
                    //     left: 15.0,
                    //     right: 15.0,
                    //     bottom: 10.0,
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               Navigator.of(context).pop();
                    //             },
                    //             child: const Icon(
                    //               Icons.arrow_back,
                    //               color: Colors.black,
                    //               size: 30,
                    //             ),
                    //           ),
                    //           Row(
                    //             children: [
                    // IconButton(
                    //   icon: AnimatedSwitcher(
                    //       duration: const Duration(seconds: 1),
                    //       transitionBuilder: (child, anim) =>
                    //           RotationTransition(
                    //             turns: child.key == ValueKey('icon1')
                    //                 ? Tween<double>(begin: 1, end: -1)
                    //                     .animate(anim)
                    //                 : Tween<double>(begin: -1, end: 1)
                    //                     .animate(anim),
                    //             child: FadeTransition(
                    //                 opacity: anim, child: child),
                    //           ),
                    //       child: _currIndex == 0
                    //           ? Icon(Icons.sync,
                    //               color: Colors.black,
                    //               key: const ValueKey('icon1'))
                    //           : Icon(
                    //               Icons.sync,
                    //               color: Colors.black,
                    //               key: const ValueKey('icon2'),
                    //             )),
                    //   onPressed: () {
                    //     _onrefresh2();
                    //     setState(() {
                    //       _currIndex = _currIndex == 0 ? 1 : 0;
                    //     });
                    //   },
                    // ),
                    //               SizedBox(
                    //                 width: 10,
                    //               ),
                    //               GestureDetector(
                    //                 onTap: () {
                    //                   showDialog(
                    //                       context: context,
                    //                       builder: (context) {
                    //                         return SimpleDialog(
                    //                           backgroundColor:
                    //                               const Color.fromRGBO(46, 46, 46, 1),
                    //                           contentPadding:
                    //                               const EdgeInsets.all(20),
                    //                           title: Column(
                    //                             children: [
                    //                               Align(
                    //                                 alignment: Alignment.center,
                    //                                 child: Text(
                    //                                   Provider.of<LanguageProvider>(
                    //                                               context)
                    //                                           .isTamil
                    //                                       ? "தகவல்"
                    //                                       : "INFO",
                    //                                   style: const TextStyle(
                    //                                     fontSize: 20,
                    //                                     fontWeight: FontWeight.bold,
                    //                                     color: Colors.blueAccent,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               const SizedBox(
                    //                                 height: 5,
                    //                               ),
                    //                               Align(
                    //                                 alignment: Alignment.center,
                    //                                 child: Text(
                    //                                   textAlign: TextAlign.center,
                    //                                   Provider.of<LanguageProvider>(
                    //                                               context)
                    //                                           .isTamil
                    //                                       ? "அனைத்து பயனர்களும்"
                    //                                       : "All users",
                    //                                   style: const TextStyle(
                    //                                     fontSize: 17,
                    //                                     fontWeight: FontWeight.bold,
                    //                                     color: Colors.white,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                           children: [
                    //                             Text(
                    //                               Provider.of<LanguageProvider>(
                    //                                           context)
                    //                                       .isTamil
                    //                                   ? "அனைத்து பயனர்களும் இங்கு பட்டியலிடப்பட்டுள்ளனர், குறிப்பிட்ட பயனர் விவரங்களைத் திருத்த, தேடல் பட்டியில் தட்டவும்"
                    //                                   : "All user are listed here grouped by their roles, To edit specific user details tap on the search bar",
                    //                               style: const TextStyle(
                    //                                 fontSize: 17,
                    //                                 // fontWeight: FontWeight.bold,
                    //                                 color: Colors.white,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         );
                    //                       });
                    //                 },
                    //                 child: const Icon(
                    //                   Icons.info,
                    //                   size: 25,
                    //                 ),
                    //               ),
                    //             ],
                    //           )
                    //         ],
                    //       ),
                    //       const SizedBox(
                    //         height: 5,
                    //       ),
                    //       Text(
                    //         overflow: TextOverflow.visible,
                    //         Provider.of<LanguageProvider>(context).isTamil
                    //             ? "அனைத்து பயனர்களும்"
                    //             : "ALL USERS",
                    //         style: GoogleFonts.manrope(
                    //           color: Colors.black,
                    //           fontSize: 35,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: lighterbackgroundblue,
                          // borderRadius: BorderRadius.only(
                          //   topLeft: Radius.circular(37.0),
                          //   topRight: Radius.circular(37.0),
                          // ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 15.0,
                                  left: 15,
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Hero(
                                  tag: "search bar",
                                  child: Material(
                                    elevation: 1,
                                    shadowColor: lightbackgroundblue,
                                    borderRadius: BorderRadius.circular(40),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserSearchPage(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromRGBO(
                                                  158, 158, 158, 1),
                                              spreadRadius: -5,
                                              blurRadius: 5,
                                              // offset:
                                              // const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.search,
                                              size: 25,
                                              color: darkblue.withValues(
                                                  alpha: 0.6),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              Provider.of<LanguageProvider>(
                                                          context)
                                                      .isTamil
                                                  ? "பயனர்பெயர்"
                                                  : 'Search by username',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize:
                                                    Provider.of<LanguageProvider>(
                                                                context)
                                                            .isTamil
                                                        ? 16
                                                        : 18,
                                                color: darkblue.withValues(
                                                    alpha: 0.6),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Hero(
                                //   tag: "search bar",
                                //   child: SizedBox(
                                //     height: 60,
                                //     width: MediaQuery.of(context).size.width,
                                //     child: ElevatedButton(
                                //       onPressed: () {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (context) => UserSearchPage(),
                                //           ),
                                //         );
                                //         fetchUsers();
                                //       },
                                //       style: ElevatedButton.styleFrom(
                                //         elevation: 0,
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(40.0),
                                //         ),
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 25, vertical: 15),
                                //         backgroundColor: Colors.white,
                                //       ),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.start,
                                //         children: [
                                //           const Icon(
                                //             Icons.search,
                                //             size: 25,
                                //             color: Colors.black54,
                                //           ),
                                //           const SizedBox(
                                //             width: 10,
                                //           ),
                                //           Text(
                                //             Provider.of<LanguageProvider>(context)
                                //                     .isTamil
                                //                 ? "பயனர்பெயர்"
                                //                 : 'Search by username',
                                //             style: const TextStyle(
                                //               fontSize: 17,
                                //               color: Colors.black54,
                                //               fontWeight: FontWeight.bold,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                  left: 8,
                                  // top: 10,
                                  // bottom: 10,
                                ),
                                child: FutureBuilder<List<AllUsersModel>>(
                                  future: futureUsers,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Fetching data",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize:
                                                    Provider.of<LanguageProvider>(
                                                                context)
                                                            .isTamil
                                                        ? 17
                                                        : 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SpinKitThreeBounce(
                                              color: const Color.fromARGB(
                                                  255, 130, 111, 238),
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Center(
                                          child: Text('No users found'));
                                    } else {
                                      List<AllUsersModel> users =
                                          snapshot.data!;
                                      List<AllUsersModel> userRoles1 = users
                                          .where((user) => user.role == 1)
                                          .toList();
                                      List<AllUsersModel> userRoles2 = users
                                          .where((user) => user.role == 2)
                                          .toList();
                                      List<AllUsersModel> userRoles3 = users
                                          .where((user) => user.role == 3)
                                          .toList();
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            _buildRoleTile(
                                              Provider.of<LanguageProvider>(
                                                          context)
                                                      .isTamil
                                                  ? "பயனர்கள்"
                                                  : 'Users',
                                              userRoles2,
                                              true,
                                            ),
                                            _buildRoleTile(
                                                Provider.of<LanguageProvider>(
                                                            context)
                                                        .isTamil
                                                    ? "நிர்வாகிகள்"
                                                    : 'Admins',
                                                userRoles1,
                                                false),
                                            _buildRoleTile(
                                                Provider.of<LanguageProvider>(
                                                            context)
                                                        .isTamil
                                                    ? "வளாகம்"
                                                    : 'Campus',
                                                userRoles3,
                                                false),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildRoleTile(
      String title, List<AllUsersModel> users, bool isexpanded) {
    return Card(
      color: lightbackgroundblue,
      elevation: 0,

      // shadowColor: lightbackgroundblue,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        controlAffinity: ListTileControlAffinity.trailing,
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 12.0,
                horizontalMargin: 12.0,
                dataRowMaxHeight: 70,
                columns: [
                  DataColumn(
                    label: Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "ஐடி"
                          : 'ID',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: Provider.of<LanguageProvider>(context).isTamil
                            ? 15
                            : 17,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "பயனர் பெயர்"
                          : 'Username',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: Provider.of<LanguageProvider>(context).isTamil
                            ? 15
                            : 17,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "முதல் பெயர்"
                          : 'First Name',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: Provider.of<LanguageProvider>(context).isTamil
                            ? 15
                            : 17,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "கடைசி பெயர்"
                          : 'Last Name',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: Provider.of<LanguageProvider>(context).isTamil
                            ? 15
                            : 17,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "தொலைபேசி எண்"
                          : 'Phone Number',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: Provider.of<LanguageProvider>(context).isTamil
                            ? 15
                            : 17,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "பணியாளர் ஐடி"
                          : 'Staff Id',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: Provider.of<LanguageProvider>(context).isTamil
                            ? 15
                            : 17,
                      ),
                    ),
                  ),
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
                      ]),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  List<AllUsersModel> _allUsers = [];
  List<AllUsersModel> _filteredUsers = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(_filterUsers);
    setState(() {});
  }

  Future<void> _fetchUsers() async {
    // Replace with your API endpoint
    final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.userdata));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          _allUsers = data.map((json) => AllUsersModel.fromJson(json)).toList();
          _filteredUsers = _allUsers;
        });
      }
    } else {
      // Handle the error here
      throw Exception('Failed to load users');
    }
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers
          .where((user) => user.username!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onrefresh() async {
    await Future.delayed(Duration(seconds: 1));

    try {
      await _fetchUsers();
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(229, 229, 228, 1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: lighterbackgroundblue,
          // appBar: AppBar(
          //   title: const Text('User Search'),
          // ),
          body: Column(
            children: [
              // const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(
                  right: 15.0,
                  left: 15,
                  top: 10,
                  bottom: 10,
                ),
                child: Hero(
                  tag: "search bar",
                  child: Material(
                    elevation: 1,
                    shadowColor: lightbackgroundblue,
                    borderRadius: BorderRadius.circular(40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(158, 158, 158, 1),
                              spreadRadius: -5,
                              blurRadius: 5,
                              // offset:
                              // const Offset(0, 4),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          maxLines: null,
                          // expands: true,
                          controller: _searchController,
                          decoration: InputDecoration(
                            icon: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 25,
                                  color: darkblue.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            border: InputBorder.none,
                            hintText:
                                Provider.of<LanguageProvider>(context).isTamil
                                    ? "பயனர்பெயர்"
                                    : "Search by username",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: darkblue.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _filteredUsers.isEmpty
                    ? RefreshIndicator(
                        onRefresh: _onrefresh,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "காலியாக உள்ளது"
                                  : "No result",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SpinKitThreeBounce(
                              color: Color.fromARGB(255, 97, 81, 188),
                              size: 30,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          right: 15.0,
                          left: 15,
                          // top: 10,
                          // bottom: 10,
                        ),
                        child: RefreshIndicator(
                          onRefresh: _onrefresh,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserEditPage(
                                          user: user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: lightbackgroundblue,
                                          spreadRadius: -2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GetStringUtils(user.username!)
                                                .capitalize(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: darkblue,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            Provider.of<LanguageProvider>(
                                                        context)
                                                    .isTamil
                                                ? "+91${user.phoneNumber!.toString()}"
                                                : 'Mobile +91${user.phoneNumber!.toString()}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension GetStringUtils on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}

extension StringExtension on String {
  String capitalize() {
    return toUpperCase();
  }
}

class UserEditPage extends StatefulWidget {
  final AllUsersModel user;
  const UserEditPage({required this.user, super.key});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  String dropdownValue = 'user';
  int selectedRole = 1;

  late TextEditingController usernameController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController staffIdController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user.username);
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber?.toString());
    staffIdController = TextEditingController(text: widget.user.staffId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageProvider = Provider.of<LanguageProvider>(context);
  }

  late LanguageProvider _languageProvider;
  Future<void> updateUser(AllUsersModel user) async {
    try {
      final response = await http.put(
        Uri.parse(
            '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.userdata}/${user.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            useractiondis = true;
            DelightToastBar(
              position: DelightSnackbarPosition.top,
              autoDismiss: true,
              animationDuration: const Duration(milliseconds: 100),
              snackbarDuration: const Duration(milliseconds: 800),
              builder: (context) => ToastCard(
                color: alertgreen,
                leading: const Icon(
                  Icons.done,
                  size: 28,
                  color: Colors.white,
                ),
                title: Text(
                  _languageProvider.isTamil
                      ? "பயனர் வெற்றிகரமாக புதுப்பிக்கப்பட்டார்"
                      : "User successfully updated",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ).show(context);
          });
        }
        // Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }

      if (response.statusCode != 200) {
        if (mounted) {
          setState(() {
            DelightToastBar(
              position: DelightSnackbarPosition.top,
              autoDismiss: true,
              animationDuration: const Duration(milliseconds: 700),
              snackbarDuration: const Duration(seconds: 2),
              builder: (context) => ToastCard(
                color: alertred,
                leading: const Icon(
                  Icons.notification_important_outlined,
                  size: 28,
                  color: Colors.white,
                ),
                title: Text(
                  _languageProvider.isTamil
                      ? "பயனரைப் புதுப்பிப்பதில் பிழை"
                      : "Error updating user",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ).show(context);
            useractiondis = false;
          });
        }
        // throw Exception('Failed to update user');
      }
    } catch (e) {
      print('Error decoding response body: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.userdata}/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            useractiondis = true;
            DelightToastBar(
              position: DelightSnackbarPosition.top,
              autoDismiss: true,
              animationDuration: const Duration(milliseconds: 100),
              snackbarDuration: const Duration(milliseconds: 800),
              builder: (context) => ToastCard(
                color: alertgreen,
                leading: const Icon(
                  Icons.done,
                  size: 28,
                  color: Colors.white,
                ),
                title: Text(
                  _languageProvider.isTamil
                      ? "பயனர் வெற்றிகரமாக புதுப்பிக்கப்பட்டார்"
                      : "User successfully deleted",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ).show(context);
          });
        }
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        // Navigator.of(context).pop();
      }

      if (response.statusCode != 200) {
        if (mounted) {
          setState(() {
            DelightToastBar(
              position: DelightSnackbarPosition.top,
              autoDismiss: true,
              animationDuration: const Duration(milliseconds: 700),
              snackbarDuration: const Duration(seconds: 2),
              builder: (context) => ToastCard(
                color: alertred,
                leading: const Icon(
                  Icons.notification_important_outlined,
                  size: 28,
                  color: Colors.white,
                ),
                title: Text(
                  _languageProvider.isTamil
                      ? "பயனரைப் புதுப்பிப்பதில் பிழை"
                      : "Error updating user",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ).show(context);
            useractiondis = false;
          });
        }
        // throw Exception('Failed to update user');
      }
    } catch (e) {}
  }

  bool useractiondis = false;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: darkblue,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            toolbarHeight: 70,
            // backgroundColor: Colors.red,
            titleSpacing: 0,
            title: Text(
              overflow: TextOverflow.visible,
              Provider.of<LanguageProvider>(context).isTamil
                  ? "பயனரைத் திருத்து"
                  : "EDIT USER",
              style: TextStyle(
                color: darkblue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: lighterbackgroundblue,
          body: useractiondis
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "சேர்க்கப்படுகிறது"
                            : "Adding data",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize:
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? 17
                                  : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SpinKitThreeBounce(
                        color: const Color.fromARGB(255, 130, 111, 238),
                        size: 30,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.only(
                    //     // top: 50.0,
                    //     left: 15.0,
                    //     right: 15.0,
                    //     bottom: 20.0,
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Padding(
                    //         padding: const EdgeInsets.only(top: 10),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           children: [
                    //             GestureDetector(
                    //               onTap: () {
                    //                 Navigator.of(context).pop();
                    //               },
                    //               child: const Icon(
                    //                 Icons.arrow_back,
                    //                 color: Colors.white,
                    //                 size: 30,
                    //               ),
                    //             ),
                    //             const SizedBox(
                    //               width: 10,
                    //             ),
                    //             Text(
                    //               overflow: TextOverflow.visible,
                    //               Provider.of<LanguageProvider>(context).isTamil
                    //                   ? "பயனரைத் திருத்து"
                    //                   : "EDIT USER",
                    //               style: GoogleFonts.manrope(
                    //                 color: Colors.white,
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 150,
                        decoration: BoxDecoration(
                          color: lighterbackgroundblue,
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 15.0,
                              left: 15,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "முதல் பெயர்"
                                      : 'First Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: darkblue,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Badconditionields(
                                  controller: firstNameController,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "முதல் பெயர்"
                                          : 'First Name',
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "கடைசி பெயர்"
                                      : 'Last Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: darkblue,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Badconditionields(
                                  controller: lastNameController,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "கடைசி பெயர்"
                                          : 'Last Name',
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "பயனர் பெயர்"
                                      : 'UserName',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: darkblue,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Badconditionields(
                                  controller: usernameController,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "பயனர் பெயர்"
                                          : 'Username',
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "தொலைபேசி எண்"
                                      : 'Phone Number',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: darkblue,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Badconditionields(
                                  controller: phoneNumberController,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "தொலைபேசி எண்"
                                          : 'Phone Number',
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "பணியாளர் ஐடி"
                                      : 'Staff Id',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: darkblue,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Badconditionields(
                                  controller: staffIdController,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "பணியாளர் ஐடி"
                                          : 'Staff Id',
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (usernameController.text.isEmpty ||
                                              firstNameController
                                                  .text.isEmpty ||
                                              lastNameController.text.isEmpty ||
                                              phoneNumberController
                                                  .text.isEmpty ||
                                              staffIdController.text.isEmpty) {
                                            setState(() {
                                              DelightToastBar(
                                                position:
                                                    DelightSnackbarPosition.top,
                                                autoDismiss: true,
                                                animationDuration:
                                                    const Duration(
                                                        milliseconds: 700),
                                                snackbarDuration:
                                                    const Duration(seconds: 2),
                                                builder: (context) => ToastCard(
                                                  color: alertred,
                                                  leading: const Icon(
                                                    Icons
                                                        .notification_important_outlined,
                                                    size: 28,
                                                    color: Colors.white,
                                                  ),
                                                  title: Text(
                                                    _languageProvider.isTamil
                                                        ? "அனைத்து புலங்களையும் நிரப்பவும்"
                                                        : "fill all the fields",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ).show(context);
                                            });
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return
                                                    // Dialog(
                                                    //   backgroundColor: Colors.white,
                                                    //   shape: RoundedRectangleBorder(
                                                    //     borderRadius:
                                                    //         BorderRadius.circular(15.0),
                                                    //   ),
                                                    //   child: ClipRRect(
                                                    //     borderRadius:
                                                    //         BorderRadius.circular(15.0),
                                                    //     child: Padding(
                                                    //       padding: const EdgeInsets.only(
                                                    //         top: 3,
                                                    //         left: 3,
                                                    //         right: 3,
                                                    //         bottom: 3,
                                                    //       ),
                                                    //       child: Container(
                                                    //         width: 150,
                                                    //         decoration:
                                                    //             const BoxDecoration(
                                                    //           color: Colors.white,
                                                    //           // borderRadius:
                                                    //           //     BorderRadius.only(
                                                    //           //   bottomLeft:
                                                    //           //       Radius.circular(37),
                                                    //           //   bottomRight:
                                                    //           //       Radius.circular(37),
                                                    //           //   topLeft:
                                                    //           //       Radius.circular(37),
                                                    //           //   topRight:
                                                    //           //       Radius.circular(37),
                                                    //           // ),
                                                    //         ),
                                                    //         child: Padding(
                                                    //           padding: const EdgeInsets
                                                    //               .symmetric(
                                                    //               horizontal: 20.0),
                                                    //           child: Column(
                                                    //             mainAxisSize:
                                                    //                 MainAxisSize.min,
                                                    //             crossAxisAlignment:
                                                    //                 CrossAxisAlignment
                                                    //                     .center,
                                                    //             children: [
                                                    //               const SizedBox(
                                                    //                 height: 20,
                                                    //               ),
                                                    //               Text(
                                                    //                 Provider.of<LanguageProvider>(
                                                    //                             context)
                                                    //                         .isTamil
                                                    //                     ? "நீங்கள் உறுதியாக இருக்கிறீர்களா?"
                                                    //                     : "Are you sure?",
                                                    //                 style: GoogleFonts
                                                    //                     .manrope(
                                                    //                   color: Colors.black,
                                                    //                   fontSize: Provider.of<
                                                    //                                   LanguageProvider>(
                                                    //                               context)
                                                    //                           .isTamil
                                                    //                       ? 19
                                                    //                       : 23,
                                                    //                   fontWeight:
                                                    //                       FontWeight.w500,
                                                    //                 ),
                                                    //               ),
                                                    //               const SizedBox(
                                                    //                 height: 20,
                                                    //               ),
                                                    //               Row(
                                                    //                 mainAxisAlignment:
                                                    //                     MainAxisAlignment
                                                    //                         .spaceEvenly,
                                                    //                 children: [
                                                    //                   OutlinedButton(
                                                    //                     style:
                                                    //                         OutlinedButton
                                                    //                             .styleFrom(
                                                    //                       padding:
                                                    //                           const EdgeInsets
                                                    //                               .symmetric(
                                                    //                         vertical: 8,
                                                    //                         horizontal:
                                                    //                             32,
                                                    //                       ),
                                                    //                       foregroundColor:
                                                    //                           Colors
                                                    //                               .black87,
                                                    //                       shape:
                                                    //                           RoundedRectangleBorder(
                                                    //                         borderRadius:
                                                    //                             BorderRadius
                                                    //                                 .circular(
                                                    //                                     5),
                                                    //                       ),
                                                    //                       side:
                                                    //                           const BorderSide(
                                                    //                         color: Colors
                                                    //                             .black87,
                                                    //                       ),
                                                    //                     ),
                                                    //                     child: Text(
                                                    //                       Provider.of<LanguageProvider>(
                                                    //                                   context)
                                                    //                               .isTamil
                                                    //                           ? "இல்லை"
                                                    //                           : "No",
                                                    //                       style: GoogleFonts.manrope(
                                                    //                           color: Colors
                                                    //                               .black87,
                                                    //                           fontWeight:
                                                    //                               FontWeight
                                                    //                                   .w500,
                                                    //                           fontSize:
                                                    //                               Provider.of<LanguageProvider>(context).isTamil
                                                    //                                   ? 12
                                                    //                                   : 15),
                                                    //                     ),
                                                    //                     onPressed: () {
                                                    //                       Navigator.of(
                                                    //                               context)
                                                    //                           .pop();
                                                    //                     },
                                                    //                   ),
                                                    //                   ElevatedButton(
                                                    //                     style:
                                                    //                         ButtonStyle(
                                                    //                       padding:
                                                    //                           WidgetStatePropertyAll(
                                                    //                         EdgeInsets
                                                    //                             .symmetric(
                                                    //                           vertical: 8,
                                                    //                           // horizontal:
                                                    //                           //     32,
                                                    //                         ),
                                                    //                       ),
                                                    //                       backgroundColor:
                                                    //                           WidgetStatePropertyAll(
                                                    //                         paleblue,
                                                    //                       ),
                                                    //                       shape:
                                                    //                           WidgetStatePropertyAll(
                                                    //                         RoundedRectangleBorder(
                                                    //                           borderRadius:
                                                    //                               BorderRadius
                                                    //                                   .all(
                                                    //                             Radius
                                                    //                                 .circular(
                                                    //                                     5),
                                                    //                           ),
                                                    //                         ),
                                                    //                       ),
                                                    //                     ),
                                                    //                     child: const Icon(
                                                    //                       Icons.check,
                                                    //                       color: Colors
                                                    //                           .white,
                                                    //                     ),
                                                    //                     onPressed: () {
                                                    // final updatedUser =
                                                    //     AllUsersModel(
                                                    //   id: widget
                                                    //       .user.id,
                                                    //   username:
                                                    //       usernameController
                                                    //           .text,
                                                    //   firstName:
                                                    //       firstNameController
                                                    //           .text,
                                                    //   lastName:
                                                    //       lastNameController
                                                    //           .text,
                                                    //   phoneNumber: int
                                                    //       .tryParse(
                                                    //           phoneNumberController
                                                    //               .text),
                                                    //   staffId:
                                                    //       staffIdController
                                                    //           .text,
                                                    // );
                                                    // updateUser(
                                                    //     updatedUser);
                                                    //                       setState(() {
                                                    //                         useractiondis =
                                                    //                             true;
                                                    //                       });
                                                    //                     },
                                                    //                   ),
                                                    //                 ],
                                                    //               ),
                                                    //               const SizedBox(
                                                    //                 height: 20,
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // );
                                                    Dialog(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 3,
                                                        left: 3,
                                                        right: 3,
                                                        bottom: 3,
                                                      ),
                                                      child: Container(
                                                        width: 150,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 20.0,
                                                            vertical: 20,
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                Provider.of<LanguageProvider>(
                                                                            context)
                                                                        .isTamil
                                                                    ? "நீங்கள் உறுதியாக இருக்கிறீர்களா?"
                                                                    : "Are you sure?",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      darkblue,
                                                                  fontSize:
                                                                      Provider.of<LanguageProvider>(context)
                                                                              .isTamil
                                                                          ? 19
                                                                          : 23,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 30,
                                                              ),
                                                              IntrinsicHeight(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          Provider.of<LanguageProvider>(context).isTamil
                                                                              ? "இல்லை"
                                                                              : "No",
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: Provider.of<LanguageProvider>(context).isTamil ? 14 : 17),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    VerticalDivider(
                                                                      color: Colors
                                                                          .grey
                                                                          .withValues(
                                                                              alpha: 0.5),
                                                                      thickness:
                                                                          1,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        final updatedUser =
                                                                            AllUsersModel(
                                                                          id: widget
                                                                              .user
                                                                              .id,
                                                                          username:
                                                                              usernameController.text,
                                                                          firstName:
                                                                              firstNameController.text,
                                                                          lastName:
                                                                              lastNameController.text,
                                                                          phoneNumber:
                                                                              int.tryParse(phoneNumberController.text),
                                                                          staffId:
                                                                              staffIdController.text,
                                                                        );
                                                                        updateUser(
                                                                            updatedUser);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        setState(
                                                                            () {
                                                                          useractiondis =
                                                                              true;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          Provider.of<LanguageProvider>(context).isTamil
                                                                              ? "ஆம்"
                                                                              : "yes",
                                                                          style: TextStyle(
                                                                              color: paleblue,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: Provider.of<LanguageProvider>(context).isTamil ? 14 : 17),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          // width: double.maxFinite,
                                          decoration: const BoxDecoration(
                                            color: const Color.fromRGBO(
                                                130, 204, 146, 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              Provider.of<LanguageProvider>(
                                                          context)
                                                      .isTamil
                                                  ? "புதுப்பிக்க"
                                                  : "Update",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //     right: 8,
                                    //     left: 8,
                                    //   ),
                                    //   child: Divider(
                                    //     height: 30,
                                    //     thickness: 3,
                                    //     color: Colors.grey[400],
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   height: 16,
                                    // ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return
                                                  // Dialog(
                                                  //   backgroundColor: Colors.white,
                                                  //   shape: RoundedRectangleBorder(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(15.0),
                                                  //   ),
                                                  //   child: ClipRRect(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(15.0),
                                                  //     child: Padding(
                                                  //       padding: const EdgeInsets.only(
                                                  //         top: 3,
                                                  //         left: 3,
                                                  //         right: 3,
                                                  //         bottom: 3,
                                                  //       ),
                                                  //       child: Container(
                                                  //         width: 150,
                                                  //         // decoration: const BoxDecoration(
                                                  //         //   color: Colors.white,
                                                  //         //   borderRadius:
                                                  //         //       BorderRadius.only(
                                                  //         //     bottomLeft:
                                                  //         //         Radius.circular(37),
                                                  //         //     bottomRight:
                                                  //         //         Radius.circular(37),
                                                  //         //     topLeft:
                                                  //         //         Radius.circular(37),
                                                  //         //     topRight:
                                                  //         //         Radius.circular(37),
                                                  //         //   ),
                                                  //         // ),
                                                  //         child: Padding(
                                                  //           padding: const EdgeInsets
                                                  //               .symmetric(
                                                  //               horizontal: 20.0),
                                                  //           child: Column(
                                                  //             mainAxisSize:
                                                  //                 MainAxisSize.min,
                                                  //             crossAxisAlignment:
                                                  //                 CrossAxisAlignment
                                                  //                     .center,
                                                  //             children: [
                                                  //               const SizedBox(
                                                  //                 height: 20,
                                                  //               ),
                                                  //               Text(
                                                  //                 Provider.of<LanguageProvider>(
                                                  //                             context)
                                                  //                         .isTamil
                                                  //                     ? "நீங்கள் உறுதியாக இருக்கிறீர்களா?"
                                                  //                     : "Are you sure?",
                                                  //                 style:
                                                  //                     GoogleFonts.manrope(
                                                  //                   color: Colors.black,
                                                  //                   fontSize: Provider.of<
                                                  //                                   LanguageProvider>(
                                                  //                               context)
                                                  //                           .isTamil
                                                  //                       ? 19
                                                  //                       : 23,
                                                  //                   fontWeight:
                                                  //                       FontWeight.w500,
                                                  //                 ),
                                                  //               ),
                                                  //               const SizedBox(
                                                  //                 height: 20,
                                                  //               ),
                                                  //               Row(
                                                  //                 mainAxisAlignment:
                                                  //                     MainAxisAlignment
                                                  //                         .spaceEvenly,
                                                  //                 children: [
                                                  //                   OutlinedButton(
                                                  //                     style:
                                                  //                         OutlinedButton
                                                  //                             .styleFrom(
                                                  //                       padding:
                                                  //                           const EdgeInsets
                                                  //                               .symmetric(
                                                  //                         vertical: 8,
                                                  //                         horizontal: 32,
                                                  //                       ),
                                                  //                       foregroundColor:
                                                  //                           Colors
                                                  //                               .black87,
                                                  //                       shape:
                                                  //                           RoundedRectangleBorder(
                                                  //                         borderRadius:
                                                  //                             BorderRadius
                                                  //                                 .circular(
                                                  //                                     5),
                                                  //                       ),
                                                  //                       side:
                                                  //                           const BorderSide(
                                                  //                         color: Colors
                                                  //                             .black87,
                                                  //                       ),
                                                  //                     ),
                                                  //                     child: Text(
                                                  //                       Provider.of<LanguageProvider>(
                                                  //                                   context)
                                                  //                               .isTamil
                                                  //                           ? "இல்லை"
                                                  //                           : "No",
                                                  //                       style: GoogleFonts.manrope(
                                                  //                           color: Colors
                                                  //                               .black87,
                                                  //                           fontWeight:
                                                  //                               FontWeight
                                                  //                                   .w500,
                                                  //                           fontSize:
                                                  //                               Provider.of<LanguageProvider>(context)
                                                  //                                       .isTamil
                                                  //                                   ? 12
                                                  //                                   : 15),
                                                  //                     ),
                                                  //                     onPressed: () {
                                                  //                       Navigator.of(
                                                  //                               context)
                                                  //                           .pop();
                                                  //                     },
                                                  //                   ),
                                                  //                   ElevatedButton(
                                                  //                     style: ButtonStyle(
                                                  //                       padding:
                                                  //                           WidgetStatePropertyAll(
                                                  //                         EdgeInsets
                                                  //                             .symmetric(
                                                  //                           vertical: 8,
                                                  //                           // horizontal:
                                                  //                           //     32,
                                                  //                         ),
                                                  //                       ),
                                                  //                       backgroundColor:
                                                  //                           WidgetStatePropertyAll(
                                                  //                         paleblue,
                                                  //                       ),
                                                  //                       shape:
                                                  //                           WidgetStatePropertyAll(
                                                  //                         RoundedRectangleBorder(
                                                  //                           borderRadius:
                                                  //                               BorderRadius
                                                  //                                   .all(
                                                  //                             Radius
                                                  //                                 .circular(
                                                  //                                     5),
                                                  //                           ),
                                                  //                         ),
                                                  //                       ),
                                                  //                     ),
                                                  //                     child: const Icon(
                                                  //                       Icons.check,
                                                  //                       color:
                                                  //                           Colors.white,
                                                  //                     ),
                                                  //                     onPressed: () {
                                                  // deleteUser((widget
                                                  //     .user.id!));
                                                  // setState(() {
                                                  //   useractiondis =
                                                  //       true;
                                                  // });
                                                  //                     },
                                                  //                   ),
                                                  //                 ],
                                                  //               ),
                                                  //               const SizedBox(
                                                  //                 height: 20,
                                                  //               ),
                                                  //             ],
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // );
                                                  Dialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 3,
                                                      left: 3,
                                                      right: 3,
                                                      bottom: 3,
                                                    ),
                                                    child: Container(
                                                      width: 150,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 20.0,
                                                          vertical: 20,
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              Provider.of<LanguageProvider>(
                                                                          context)
                                                                      .isTamil
                                                                  ? "நீங்கள் உறுதியாக இருக்கிறீர்களா?"
                                                                  : "Are you sure?",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: Provider.of<LanguageProvider>(
                                                                            context)
                                                                        .isTamil
                                                                    ? 19
                                                                    : 23,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            IntrinsicHeight(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        Provider.of<LanguageProvider>(context).isTamil
                                                                            ? "இல்லை"
                                                                            : "No",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            fontSize: Provider.of<LanguageProvider>(context).isTamil
                                                                                ? 14
                                                                                : 17),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  VerticalDivider(
                                                                    color: Colors
                                                                        .grey
                                                                        .withValues(
                                                                            alpha:
                                                                                0.5),
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      deleteUser((widget
                                                                          .user
                                                                          .id!));
                                                                      setState(
                                                                          () {
                                                                        useractiondis =
                                                                            true;
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        Provider.of<LanguageProvider>(context).isTamil
                                                                            ? "ஆம்"
                                                                            : "yes",
                                                                        style: TextStyle(
                                                                            color:
                                                                                paleblue,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize: Provider.of<LanguageProvider>(context).isTamil
                                                                                ? 14
                                                                                : 17),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          // width: double.maxFinite,
                                          decoration: const BoxDecoration(
                                            color: const Color.fromARGB(
                                                215, 244, 67, 54),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              Provider.of<LanguageProvider>(
                                                          context)
                                                      .isTamil
                                                  ? "நீக்க"
                                                  : "Delete",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
