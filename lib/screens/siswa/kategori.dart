import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/screens/admin/bottomnav.dart';
import 'package:guruku/screens/siswa/list_kategori.dart';
import 'package:guruku/styles.dart';
import 'package:guruku/utils.dart';
import 'package:intl/intl.dart';

class KategoriSiswa extends StatefulWidget {
  const KategoriSiswa({super.key});

  @override
  State<KategoriSiswa> createState() => _KategoriState();
}

class _KategoriState extends State<KategoriSiswa> {
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

  void delete(String deskripsi) async {
    try {
      final response = await Dio().delete('${Network().baseUrl}/mata_pelajaran',
          data: {'deskripsi': deskripsi});
      if (response.statusCode == 200) {
        Navigate(context, const Admin(index: 2));
        debugPrint('Delete success');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
                    childAspectRatio: 0.63,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    crossAxisCount: 4),
                itemBuilder: (context, i) {
                  return Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: InkWell(
                      
                      onTap: () {
                        Utils().Navigate(
                            context,
                            ListKategori(
                              title: data[i]['deskripsi'],
                            ));
                      },
                      child: Column(
                        children: [
                          Expanded(
                              child: Image.network(
                            data[i]['icon'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                          )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
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
                        ],
                      ),
                    ),
                  );
                })
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
