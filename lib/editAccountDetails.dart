import 'package:calendar/Database/database.dart';
import 'package:flutter/material.dart';
import 'Database/databaseProvider.dart';
import 'package:drift/drift.dart' as drift;

class EditAccountDetailsSection extends StatelessWidget {
  const EditAccountDetailsSection({Key? key}) : super(key: key);

  static const String _title = 'Edit your account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const EditAccountDetails(),
    );
  }
}

class EditAccountDetails extends StatefulWidget {
  const EditAccountDetails({Key? key}) : super(key: key);

  @override
  State<EditAccountDetails> createState() => _EditAccountDetailsState();
}

class _EditAccountDetailsState extends State<EditAccountDetails> {
  late DatabaseProvider dbProvider = DatabaseProvider();
  TextEditingController nameController =
      TextEditingController(text: 'User Test');
  TextEditingController emailController =
      TextEditingController(text: 'test@test.ro');
  TextEditingController oldPasswordController =
      TextEditingController(text: 'initial value');
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    repeatNewPasswordController.dispose();
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
                  'Account',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Edit your account details',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
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
                controller: oldPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Old password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: newPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'New password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: repeatNewPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Repeat new password',
                ),
              ),
            ),
            Container(
                height: 100,
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: ElevatedButton(
                  child: const Text('Save changes'),
                  onPressed: () {
                    final entity = UsersCompanion(
                      username: drift.Value(nameController.text),
                      email: drift.Value(emailController.text),
                      password: drift.Value(newPasswordController.text),
                    );
                    dbProvider.getDatabase().updateUser(entity).then((value) =>
                      Navigator.pop(context)
                      // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const CalendarSection(
                        //             title: 'Calendar',
                        //             username: '',
                        //           )),
                        // )
                    );
                  },
                )),
          ],
        ));
  }
}
