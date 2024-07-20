import 'package:flutter/material.dart';
import 'package:guruku/networking.dart';
import 'package:guruku/styles.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final myKey = GlobalKey<FormState>();
  final nama = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final repassword = TextEditingController();

  final String errorEmail = "Email tidak valid";
  final String errorPassword = "Kata sandi tidak valid";
  final String errorNama = 'Nama tidak valid';
  final String errorRepass = 'Kata sandi tidak sama';

  void showMsg(BuildContext c, String s) {
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(
      content: Text(s),
      duration: const Duration(seconds: 2),
    ));
  }

  String selectedValue = 'Siswa';

  void register() async {
    if (myKey.currentState!.validate()) {
      if (email.text.contains(' ')) {
        showMsg(context, 'Email tidak boleh menggunakan spasi');
      } else {
        if (password.text != repassword.text) {
          showMsg(context, 'Kata sandi tidak sama');
        } else {
          await Networking.register(
              context, nama.text, email.text, password.text, selectedValue);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration formDecoration(Color c, String label, Icon icon) {
      final formDecoration = InputDecoration(
          labelStyle: Styles().formStyle,
          prefixIcon: icon,
          filled: true,
          labelText: label,
          fillColor: c,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none));
      return formDecoration;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Daftar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
                key: myKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: Styles().formStyle,
                      controller: nama,
                      decoration: formDecoration(
                          Colors.white, 'Nama', const Icon(Icons.person)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          showMsg(context, errorNama);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: Styles().formStyle,
                      controller: email,
                      decoration: formDecoration(
                          Colors.white, 'Email', const Icon(Icons.email)),
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
                    DropdownButtonFormField(
                        decoration: formDecoration(
                            const Color.fromARGB(255, 255, 255, 255),
                            'Daftar sebagai',
                            const Icon(Icons.person)),
                        value: selectedValue,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        items: <String>['Siswa', 'Guru'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: Styles().formStyle,
                      obscureText: true,
                      controller: password,
                      decoration: formDecoration(Colors.white, 'Kata sandi',
                          const Icon(Icons.password)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          showMsg(context, errorPassword);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: Styles().formStyle,
                      obscureText: true,
                      controller: repassword,
                      decoration: formDecoration(Colors.white,
                          'Ulangi kata sandi', const Icon(Icons.password)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          showMsg(context, errorPassword);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: InkWell(
                        onTap: () {
                          register();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          child: const Center(
                            child: Text(
                              'Daftar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
