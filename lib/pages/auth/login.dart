import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_work/models/database.dart';
import 'package:team_work/pages/auth/forget_pass.dart';
import 'package:team_work/pages/auth/register.dart';
import 'package:team_work/pages/auth/users.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map;
    String message;
    var dbclass = context.read<DataBase>();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Login",
          style: GoogleFonts.ubuntu(color: Colors.white),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  height: 350,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Login & Find over 54,000 properties",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 30.0,
                                  color: Theme.of(context).primaryColor),
                            ), //BoxDecoration
                          ), //Container
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        // Text(
                        //     'Register and get access to 54,000 database records'),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Image(
                                fit: BoxFit.contain,
                                image: AssetImage('assets/images/banner6.png'),
                              ) //BoxDecoration
                              ), //Container
                        )
                      ])),
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Login',
                    style: GoogleFonts.ubuntu(
                        fontSize: 22, color: Theme.of(context).primaryColor),
                  )),
              const SizedBox(
                height: 30,
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
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const forgetPassword()));
                },
                child: Text(
                  'Forgot Password',
                  style:
                      GoogleFonts.ubuntu(color: Theme.of(context).primaryColor),
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  // color: Colors.purple,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    child: const Text('Login',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      // print(loginMap['message']);
                      var email = emailController.text.toString();
                      var password = passwordController.text.toString();
                      //print

                      dbclass.login(context, email, password);
                    },
                  )),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Does not have account?',
                    style: GoogleFonts.ubuntu(),
                  ),
                  TextButton(
                    child: Text(
                      'Register',
                      style: GoogleFonts.ubuntu(
                          fontSize: 20, color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      //signup screen
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const Register()));
                    },
                  )
                ],
              ),
            ],
          )),
    );
  }
}
