import 'package:calendar/Database/database.dart';
import 'package:calendar/register.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Database/databaseProvider.dart';
import 'calendar.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({Key? key}) : super(key: key);

  static const String _title = 'Login';

  void launchURL(String url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Login(),
        // floatingActionButton: Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     InkWell(
        //       onTap: () => launchURL('https://www.facebook.com/'),

        //       // focusColor: const Color.fromARGB(61, 33, 124, 243),
        //       // hoverColor: const Color.fromARGB(61, 33, 124, 243),
        //       // highlightColor: const Color.fromARGB(61, 33, 124, 243),
        //       borderRadius: BorderRadius.circular(50.0),
        //       child: Image.asset(
        //         'assets/logo-facebook.png',
        //         width: 50,
        //         height: 50,
        //       ),
        //     ),
        //     InkWell(
        //       onTap: () => launchURL('https://twitter.com/'),
        //       // focusColor: const Color.fromARGB(61, 33, 124, 243),
        //       // hoverColor: const Color.fromARGB(61, 33, 124, 243),
        //       // highlightColor: const Color.fromARGB(61, 33, 124, 243),
        //       borderRadius: BorderRadius.circular(50.0),
        //       child: Image.asset(
        //         'assets/logo-twitter.png',
        //         width: 50,
        //         height: 50,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DatabaseProvider dbProvider = DatabaseProvider();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Calendar',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                height: 100,
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    dbProvider
                        .getDatabase()
                        .getUser(emailController.text)
                        .then((value) => {
                              if (value != null &&
                                  value.password == passwordController.text)
                                {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CalendarSection(
                                              title: 'Calendar', user: value)),
                                      (route) => false)
                                }
                              else
                                {
                                  //TODO add login error message
                                }
                            });
                  },
                )),
            Row(
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterSection()),
                    );
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
}
