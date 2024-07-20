import 'package:flutter/material.dart';
import 'package:guruku/networking.dart';
import 'package:guruku/screens/admin/upload_foto.dart';
import 'package:guruku/styles.dart';

class EditProfilSiswa extends StatefulWidget {
  const EditProfilSiswa(
      {super.key,
      required this.id,
      required this.nama,
      required this.alamat,
      required this.url,
      required this.email,
      required this.nohp});
  final String nama;
  final String email;
  final String alamat;
  final String nohp;
  final String url;
  final int id;
  @override
  State<EditProfilSiswa> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfilSiswa> {
  final formKey = GlobalKey<FormState>();
  final nama = TextEditingController();
  final alamat = TextEditingController();
  final nohp = TextEditingController();

  @override
  void initState() {
    super.initState();
    nama.text = widget.nama;
    alamat.text = widget.alamat;
    nohp.text = widget.nohp;
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

  void saveprofil(String email) async {
    if (formKey.currentState!.validate()) {
      if (nama.text.isEmpty || alamat.text.isEmpty || nohp.text.isEmpty) {
      } else {
        _showDialog();
        await Networking.saveProfile(
            context, email, nama.text, alamat.text, int.parse(nohp.text));
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
      body: Form(
        key: formKey,
        child: Column(
          children: [
            
                 UploadFoto(id: widget.id, editing: false, url: widget.url)
                ,
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
              decoration: myDecor('No. HP', const Icon(Icons.phone_android)),
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
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
