import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/utils.dart';

class AturJadwal extends StatefulWidget {
  const AturJadwal({super.key, required this.id_guru});
  final int id_guru;

  @override
  State<AturJadwal> createState() => _AturJadwalState();
}

class _AturJadwalState extends State<AturJadwal> {
  final dio = Dio();
  DateTime selectedDateTime = DateTime.now();

  Future<void> tambahJadwal() async {
    Network().showLoadingDialog(context, 'Menambahkan jadwal');
    try {
      final response = await dio.post('${Network().baseUrl}/jadwal', data: {
        'id_guru': widget.id_guru,
        'tanggal': selectedDateTime.toString()
      });
      if (response.statusCode == 200) {
        Navigator.pop(context);
        loadJadwal();
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.toString()),
            );
          });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(picked.year, picked.month, picked.day,
              pickedTime.hour, pickedTime.minute, 0, 0, 0);
        });
        tambahJadwal();
      }
    }
  }

  List<dynamic> data = [];

  String formatDate(int i) {
    DateTime parsed = DateTime.parse(data[i]['tanggal']);
    String time =
        '${parsed.day}-${parsed.month}-${parsed.year} ${parsed.hour}:${parsed.minute}';
    return time;
  }

  Future<void> loadJadwal() async {
    try {
      final response = await dio.get('${Network().baseUrl}/jadwal',
          data: {'id_guru': widget.id_guru});
      if (response.statusCode == 200) {
        setState(() {
          data = response.data;
        });
      }
    } catch (e) {
      if(mounted) Utils().showCustomDialog(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    loadJadwal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur jadwal'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
            )),
      ),
      body: data.isNotEmpty
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Material(
                    elevation: 1,
                    color: Colors.white,
                    child: InkWell(
                      onTap: (){
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${i + 1}. ${formatDate(i)}'),
                      ),
                    ),
                  ),
                );
              })
          : const Center(child: CupertinoActivityIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectDateTime(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
