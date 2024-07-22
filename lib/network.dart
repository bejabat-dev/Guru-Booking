import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guruku/screens/admin/bottomnav.dart';
import 'package:guruku/screens/auth/forgot.dart';
import 'package:guruku/screens/home.dart';
import 'package:guruku/userdetails.dart';
import 'package:guruku/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String baseUrl = 'http://sifodsinterflour.my.id/guruku';
  final dio = Dio();

  late SharedPreferences userData;

  Future<void> login(
      BuildContext context, String email, String password) async {
    userData = await SharedPreferences.getInstance();
    showLoadingDialog(context, 'Sedang login');
    try {
      final response = await dio
          .post('$baseUrl/login', data: {'email': email, 'password': password});
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        await userData.setBool('loggedin', true);

        await userData.setString('email', email);
        if (context.mounted) await getUserData(context, email);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (e.toString().contains('401')) {
        if (context.mounted) {
          Navigator.pop(context);
          Utils().showErrorDialog(context, 'Email tidak ditemukan');
        }
      }
      if (e.toString().contains('400')) {
        if (context.mounted) {
          Navigator.pop(context);
          Utils().showErrorDialog(context, 'Kata sandi salah');
        }
      }
    }
  }

  Future<void> getFcmToken(BuildContext context, String email) async {
    final fcm = FirebaseMessaging.instance;
    final db = FirebaseFirestore.instance;
    final token = await fcm.getToken();
    if (token != null) {
      sendNotification(token);
      db.collection('users').doc(email).set({'token': token}).catchError((e) {
        Utils().showCustomDialog(context, e.toString());
      });
    }
  }

  Future<void> getUserData(BuildContext context, String email) async {
    Navigator.pop(context);
    userData = await SharedPreferences.getInstance();

    try {
      final response = await dio.get('$baseUrl/user', data: {'email': email});
      debugPrint('Try : getUserData : ${response.toString()}');
      if (response.statusCode == 200) {
        await userData.setString('data', response.toString());
        await userData.setString('email', email);
        await userData.setInt('id', response.data['id']);
        await userData.setString('nama', response.data['nama']);
        Userdetails().getToken();
      }

      String role = response.data['role'];

      if(context.mounted){
        if (role == 'siswa') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home(role: 'siswa')),
            (route) => false);
      } else if (role == 'guru') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home(role: 'guru')),
            (route) => false);
      } else if (role == 'admin') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const Admin(
                      index: 0,
                    )),
            (route) => false);
      }
      }
    } catch (e) {
      debugPrint('getUserData : ${e.toString()}');
    }
  }

  void showLoadingDialog(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(text),
                ],
              ),
            ),
          );
        });
  }
}
