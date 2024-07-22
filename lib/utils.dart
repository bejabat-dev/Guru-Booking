import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  

  void Navigate(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  String formatRupiah(int number) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  void showMessage(BuildContext context, String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(pesan),
      duration: const Duration(seconds: 2),
    ));
  }

  void showErrorDialog(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 100,
              child: Center(child: Text(text))),
            actions: [
              Center(
                  child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Konfirmasi'),
              ))
            ],
          );
        });
  }

  void showCustomDialog(BuildContext context, String text) {
    showDialog(
        barrierDismissible: false,
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
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    return;
                  },
                  child: const Center(child: Text('Batal')))
            ],
          );
        });
  }

  String formatDate(String date) {
    DateTime parsed = DateTime.parse(date);
    String time =
        '${parsed.day}-${parsed.month}-${parsed.year} ${parsed.hour}:${parsed.minute}';
    return time;
  }
}
