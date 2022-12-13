import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sql_lite/helpers/dbhelper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  bool validateLogin() {
    FormState? form = this.formKey.currentState;
    return form!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: BoxConstraints.expand(),
          // is used to create container full screen with filled content.
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background.jpg'), fit: BoxFit.cover),
          ),
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'LOGIN',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 4,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                          hintText: 'username',
                                          labelText: 'Username',
                                          icon: Icon(Icons.person),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Username tidak boleh kosong';
                                          } else {
                                            return null;
                                          }
                                        }),
                                    TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'password',
                                          labelText: 'Password',
                                          icon: Icon(Icons.lock),
                                        ),
                                        controller: passwordController,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Password tidak boleh kosong';
                                          } else {
                                            return null;
                                          }
                                        })
                                  ],
                                ),
                              )),
                          Expanded(
                              child: FloatingActionButton(
                            onPressed: () {
                              validateLogin();
                              //select tabel User
                              DbHelper dbHelper = DbHelper();
                              bool loginSukses = false;
                              dbHelper
                                  .selectUser(usernameController.text,
                                      passwordController.text)
                                  .then((mapList) {
                                mapList.forEach((element) {
                                  if (element['username'] ==
                                          usernameController.text &&
                                      element['password'] ==
                                          passwordController.text) {
                                    loginSukses = true;
                                  }
                                });
                                if (loginSukses == true) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Login Sukses"),
                                    backgroundColor: Colors.green,
                                  ));
                                  Navigator.pushNamed(context, '/dashboard',
                                      arguments: usernameController.text);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Login Gagal",
                                    ),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              });

                              //Check apakah user ada
                              //Jika user ada tampilkan dashboard
                            },
                            child: Icon(Icons.login),
                          ))
                        ])),
                Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {}, child: Text('Forgot Password?'))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Register')),
                ElevatedButton(
                    onPressed: () {
                      DbHelper dbHelper = new DbHelper();
                      dbHelper.selectAllUser().then((mapList) {
                        mapList.forEach((element) {
                          print(element);
                        });
                      });
                    },
                    child: Text('Print All Users')),
                ElevatedButton(
                    onPressed: () {}, child: Text('Delete All Users'))
              ],
            ),
          ))),
    );
  }
}
