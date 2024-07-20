import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/screens/admin/bottomnav.dart';
import 'package:guruku/screens/guru/bottomnav.dart';
import 'package:guruku/screens/siswa/bottomnav.dart';
import 'package:guruku/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Networking {
  static final dio = Dio();
  static final url = Network().baseUrl;

  static Future<void> login(
      BuildContext context, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    try {
      final response = await dio
          .post('$url/login', data: {'email': email, 'password': password});
      debugPrint(response.toString());
      var data = jsonDecode(response.toString());

      if (response.toString().contains('berhasil')) {
        if (data['role'] == 'admin') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const Admin(
                        index: 0,
                      )),
              (Route<dynamic> route) => false);
        } else if (data['role'] == 'siswa') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const Home2(
                        currentIndex: 0,
                      )),
              (Route<dynamic> route) => false);
        } else if (data['role'] == 'guru') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const GuruHome(
                        currentIndex: 0,
                      )),
              (Route<dynamic> route) => false);
        }
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void showMsg(BuildContext c, String s) {
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(
      content: Text(s),
      duration: const Duration(seconds: 2),
    ));
  }

  static Future<void> saveProfile(BuildContext context, String email,
      String nama, String alamat, int nohp) async {
    try {
      final response = await dio.put('$url/update',
          data: {'email': email, 'nama': nama, 'alamat': alamat, 'nohp': nohp});
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        Network().getUserData(context, email);
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const Home2(currentIndex: 3)),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> saveProfileGuru(BuildContext context, String email,
      String nama, String alamat, String nohp, String mataPelajaran) async {
    try {
      final response = await dio.put('$url/update/guru', data: {
        'email': email,
        'nama': nama,
        'alamat': alamat,
        'nohp': nohp,
        'mata_pelajaran': mataPelajaran
      });
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        Network().getUserData(context, email);
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const GuruHome(currentIndex: 2)),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> register(BuildContext c, String nama, String email,
      String password, String role) async {
    Utils().showCustomDialog(c, 'Mendaftarkan akun');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    try {
      final response = await Dio().post('$url/register', data: {
        'nama': nama,
        'email': email,
        'role': role.toLowerCase(),
        'password': password,
        'mata_pelajaran': 'default',
        'nohp': 0,
        'kualifikasi': 'default',
        'alamat': 'default',
        'foto_profil': 'default'
      });
      debugPrint(response.data.toString());

      if (response.statusCode.toString() == '201') {
        Network().getUserData(c, email);
        if (response.data.toString() == '{role: siswa}') {
          Navigator.pushAndRemoveUntil(
              c,
              MaterialPageRoute(
                  builder: (c) => const Home2(
                        currentIndex: 0,
                      )),
              (Route<dynamic> route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              c,
              MaterialPageRoute(
                  builder: (c) => const GuruHome(
                        currentIndex: 0,
                      )),
              (Route<dynamic> route) => false);
        }
      }
    } catch (e) {
      if (e.toString().contains('400')) {
        Navigator.pop(c);
        if (c.mounted) Utils().showErrorDialog(c, 'Email sudah terpakai');
      }
    }
  }
}
