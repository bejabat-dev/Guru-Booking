import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/screens/auth/forgot.dart';
import 'package:guruku/screens/auth/register.dart';
import 'package:guruku/styles.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  bool proceed = false;

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

  InputDecoration emailTidakValid = InputDecoration(
      prefixIcon: const Icon(Icons.email),
      fillColor: Colors.white,
      labelText: 'Email',
      labelStyle: Styles().formStyle,
      filled: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none));

  InputDecoration passwordTidakValid = InputDecoration(
      prefixIcon: const Icon(Icons.password),
      fillColor: Colors.white,
      labelText: 'Kata sandi',
      labelStyle: Styles().formStyle,
      filled: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none));

  InputDecoration formDecoration(Color c, String label, Icon icon) {
    final formDecoratiozn = InputDecoration(
        prefixIcon: icon,
        filled: true,
        labelText: label,
        labelStyle: Styles().formStyle,
        fillColor: c,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none));
    return formDecoratiozn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
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
                      onChanged: (value) {
                        if (!value.contains('@') || value.contains(' ')) {
                          setState(() {
                            emailTidakValid = Styles().errorDecoration(
                                const Icon(Icons.mail), 'Email tidak valid');
                            proceed = false;
                          });
                        } else {
                          setState(() {
                            emailTidakValid = formDecoration(
                                Colors.white, "Email", const Icon(Icons.email));
                            proceed = true;
                          });
                        }
                      },
                      style: Styles().formStyle,
                      controller: email,
                      decoration: emailTidakValid,
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
                    TextFormField(
                      onChanged: (value) {
                        if (value.length < 8) {
                          setState(() {
                            passwordTidakValid = Styles().errorDecoration(
                                const Icon(Icons.password),
                                'Kata sandi tidak valid');
                            proceed = false;
                          });
                        } else {
                          setState(() {
                            passwordTidakValid = formDecoration(Colors.white,
                                "Kata sandi", const Icon(Icons.password));
                            proceed = true;
                          });
                        }
                      },
                      style: Styles().formStyle,
                      controller: password,
                      obscureText: true,
                      enableSuggestions: false,
                      decoration: passwordTidakValid,
                      validator: (value) {
                        if (value!.isEmpty) {
                          showMsg(context, errorEmail);
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
                          if (proceed) {
                            if (myKey.currentState!.validate()) {
                              Network()
                                  .login(context, email.text, password.text);
                            }
                          } else if (email.text == 'admin') {
                            if (myKey.currentState!.validate()) {
                              Network()
                                  .login(context, email.text, password.text);
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Forgot()));
                          },
                          child: const Text(
                            'Lupa kata sandi ',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        const Text('atau '),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                          child: const Text(
                            'Buat akun ',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
