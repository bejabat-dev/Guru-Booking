import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guruku/firebase_options.dart';
import 'package:guruku/screens/admin/bottomnav.dart';
import 'package:guruku/screens/admin/edit.dart';
import 'package:guruku/screens/auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blue, foregroundColor: Colors.white),
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              color: Colors.white,
              centerTitle: true),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blue,
          splashColor: const Color.fromARGB(255, 200, 230, 255)),
      home: const Login(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/admin': (context) => const Admin(
              index: 0,
            ),
        '/edit': (context) => const Edit(),
      }));
}
