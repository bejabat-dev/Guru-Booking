import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/networking.dart';
import 'package:guruku/screens/admin/upload_foto.dart';
import 'package:guruku/styles.dart';

class EditProfilGuru extends StatefulWidget {
  const EditProfilGuru(
      {super.key,
      required this.nama,
      required this.id,
      required this.alamat,
      required this.url,
      required this.email,
      required this.mata_pelajaran,
      required this.nohp});
  final String mata_pelajaran;
  final int id;
  final String nama;
  final String email;
  final String url;
  final String alamat;
  final String nohp;

  @override
  State<EditProfilGuru> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfilGuru> {
  final formKey = GlobalKey<FormState>();
  final nama = TextEditingController();
  final alamat = TextEditingController();
  final nohp = TextEditingController();

  String selectedValue = 'Matematika';
  List<String> values = [];

  @override
  void initState() {
    super.initState();
    nama.text = widget.nama;
    alamat.text = widget.alamat;
    nohp.text = widget.nohp;
    getMataPelajaran();
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 15,
                ),
                Text('Menyimpan')
              ],
            ),
          );
        });
  }

  void getMataPelajaran() async {
    if (widget.mata_pelajaran != 'Belum disetel') {
      setState(() {
        selectedValue = widget.mata_pelajaran;
      });
    }
    try {
      final response = await Dio().get('${Network().baseUrl}/mata_pelajaran');
      debugPrint(response.toString());
      if (response.statusCode == 200) {
        setState(() {
          for (var map in response.data) {
            values.add(map['deskripsi']);
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void saveprofil(String email) async {
    if (formKey.currentState!.validate()) {
      if (nama.text.isEmpty || alamat.text.isEmpty || nohp.text.isEmpty) {
      } else {
        _showDialog();
        await Networking.saveProfileGuru(
            context, email, nama.text, alamat.text, nohp.text, selectedValue);
      }
    }
  }

  final String email = 'Email';

  InputDecoration myDecor(String text, Icon icon) {
    var s = InputDecoration(
        suffixIcon: icon,
        fillColor: Colors.white,
        filled: true,
        labelText: text,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none));
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles().customAppBar(context, 'Edit profil'),
      body: Column(
        children: [
          Column(
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UploadFoto(
                          id: widget.id, editing: false, url: widget.url),
                      TextFormField(
                        style: Styles().formStyle,
                        controller: nama,
                        decoration: myDecor('Nama', const Icon(Icons.person)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        style: Styles().formStyle,
                        controller: alamat,
                        decoration: myDecor('Alamat', const Icon(Icons.place)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        style: Styles().formStyle,
                        controller: nohp,
                        keyboardType: TextInputType.phone,
                        decoration:
                            myDecor('No. HP', const Icon(Icons.phone_android)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      values.isNotEmpty
                          ? DropdownButtonFormField<String>(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              decoration: myDecor(
                                  'Mata Pelajaran', const Icon(Icons.book)),
                              value: 'default',
                              items: values.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                });
                              })
                          : const CupertinoActivityIndicator(),
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveprofil(widget.email);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
