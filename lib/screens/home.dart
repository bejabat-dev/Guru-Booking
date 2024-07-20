import 'package:flutter/material.dart';
import 'package:guruku/screens/guru/bottomnav.dart';

import 'package:guruku/screens/siswa/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.role});
  final String role;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Widget homeWidget;

  /*final FirebaseMessaging fm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin notif =
      FlutterLocalNotificationsPlugin();
  final db = FirebaseFirestore.instance;*/

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email')!;
    /*final token = await fm.getToken();
    await db
        .collection('users')
        .doc(email)
        .set({'token': token}).catchError((e) {
      debugPrint(e.toString());
    });*/
  }

  @override
  void initState() {
    super.initState();
    init();
    if (widget.role == 'siswa') {
      homeWidget = const Home2(currentIndex: 0);
    } else if (widget.role == 'guru') {
      homeWidget = const GuruHome(
        currentIndex: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return homeWidget;
  }
}
