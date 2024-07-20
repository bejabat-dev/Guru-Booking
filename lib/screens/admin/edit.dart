import 'package:flutter/material.dart';
import 'package:guruku/styles.dart';

class Edit extends StatelessWidget {
  const Edit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: Center(
        child: SizedBox(
          height: double.infinity,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Material(
                    elevation: 2,borderRadius: BorderRadius.circular(12),
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Hapus",
                        style: Styles().whiteText,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
