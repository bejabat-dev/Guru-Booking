import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/screens/admin/bottomnav.dart';
import 'package:guruku/screens/admin/tambah_kategori.dart';
import 'package:guruku/styles.dart';
import 'package:intl/intl.dart';

class Kategori extends StatefulWidget {
  const Kategori({super.key});

  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  List<dynamic> data = [];
  Future<void> getKategori() async {
    try {
      final response = await Dio().get('${Network().baseUrl}/mata_pelajaran');
      if (response.statusCode == 200) {
        setState(() {
          data = response.data;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String formatRupiah(int number) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  @override
  void initState() {
    super.initState();
    getKategori();
  }

  void Navigate(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  void delete(int id) async {
    try {
      final response = await Dio().delete('${Network().baseUrl}/mata_pelajaran',
          data: {'id': id});
      if (response.statusCode == 200) {
        Navigate(context, const Admin(index: 2));
        debugPrint('Delete success');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showDialog(BuildContext context, String cat,int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Hapus $cat ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Batal')),
              TextButton(
                  onPressed: () {
                    delete(id);
                  },
                  child: const Text(
                    'Hapus',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Kategori',
          style: Styles().appBarText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: data.isNotEmpty
            ? GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 8,
                    crossAxisCount: 3),
                itemBuilder: (context, i) {
                  return Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: InkWell(
                      onLongPress: () {
                        _showDialog(context, data[i]['deskripsi'],data[i]['id']);
                      },
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TambahKategori(
                                      editing: true,
                                      deskripsi: data[i]['deskripsi'],
                                      tarif: data[i]['tarif'].toString(),
                                      url: data[i]['icon'],
                                    )));
                      },
                      child: Column(
                        children: [
                          Expanded(
                              child: Image.network(
                            data[i]['icon'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[i]['deskripsi'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(formatRupiah(data[i]['tarif']))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            : const Center(child: CupertinoActivityIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TambahKategori(
                        editing: false,
                        url: null,
                        deskripsi: null,
                        tarif: null,
                      )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
