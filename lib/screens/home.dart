import 'package:flutter/material.dart';
import 'package:guruku/screens/guru/bottomnav.dart';
import 'package:guruku/screens/siswa/bottomnav.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.role});
  final String role;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Widget homeWidget;

  

  @override
  void initState() {
    super.initState();

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
