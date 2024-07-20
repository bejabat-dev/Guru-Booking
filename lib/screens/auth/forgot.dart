import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/styles.dart';
import 'package:guruku/utils.dart';

class Forgot extends StatelessWidget {
  Forgot({super.key});

  final myKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  final String errorEmail = "Email tidak valid";
  final String errorPassword = "Kata sandi tidak valid";

  void showMsg(BuildContext c, String s) {
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(
      content: Text(s),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> forgot(BuildContext context) async {
    Utils().showCustomDialog(context, 'Mengirim email');

    try {
      final response = await Dio()
          .post('${Network().baseUrl}/forgot', data: {'email': email.text});
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pop(context);
          Utils().showErrorDialog(context,
              'Email berisi kode verifikasi lupa kata sandi telah dikirim. Silahkan cek email anda');
        }
      }
    } catch (e) {
      if (context.mounted) Utils().showCustomDialog(context, e.toString());
    }
  }

  InputDecoration formDecoration(Color c, String label, Icon icon) {
    final formDecoratiozn = InputDecoration(
        labelStyle: Styles().formStyle,
        prefixIcon: icon,
        filled: true,
        labelText: label,
        fillColor: c,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none));
    return formDecoratiozn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Lupa kata sandi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
                'Email berisi konfirmasi lupa kata sandi akan dikirim ke email anda jika terdaftar'),
            const SizedBox(
              height: 30,
            ),
            Form(
                key: myKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: Styles().formStyle,
                      controller: email,
                      decoration: formDecoration(
                          Colors.white, "Email", const Icon(Icons.mail)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          showMsg(context, errorEmail);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: InkWell(
                        child: TextButton(
                            onPressed: () {
                              forgot(context);
                            },
                            child: Container(
                              height: 45,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16))),
                              child: const Center(
                                child: Text(
                                  'Kirim',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

Future<void> sendNotification(String fcmToken) async {
  try {
    const String serverKey = '6b3d291b270c33b957757a247f42d73c5a089abb'; // Replace with your Firebase server key
    const String projectId = 'guru-booking'; // Replace with your Firebase project ID

    final dio = Dio();

    const url = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

    final headers = {
      'Authorization': 'Bearer $serverKey',
      'Content-Type': 'application/json',
    };

    final data = {
      'message': {
        'token': fcmToken,
        'notification': {
          'title': 'Lupa kata sandi',
          'body': 'Kode verifikasi lupa kata sandi anda adalah: ',
        },
      },
    };

    final response = await dio.post(
      url,
      options: Options(headers: headers),
      data: data,
    );

    if (response.statusCode == 200) {
      debugPrint('Notification sent successfully');
    } else {
      debugPrint('Failed to send notification. Status code: ${response.statusCode}');
      debugPrint('Error: ${response.data}');
    }
  } catch (e) {
    debugPrint('Error sending notification: $e');
  }
}
