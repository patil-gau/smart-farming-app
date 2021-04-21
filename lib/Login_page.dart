import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_agriculture/Dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:smart_agriculture/signup.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String username;
  String password;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void attemptLogIn(String username, String password) async {
    var data = jsonEncode({"UserName": username, "Password": password});
    final res = await http.post(
      Uri.http('192.168.43.242:5000', 'login'),
      body: data,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final finalresponse = jsonDecode(res.body);
    print(finalresponse['result']['status']);
    if (finalresponse['result']['status'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            'Logged in Successfully',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Invalid user',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () => {
        if (_formKey.currentState.validate())
          {
            username = _usernameController.text,
            password = _passwordController.text,
            print(username),
            print(password),
            attemptLogIn(username, password),
          }
        else
          {print("form is not validated")}
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(23.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: Colors.redAccent
            // gradient: LinearGradient(
            //     begin: Alignment.centerLeft,
            //     end: Alignment.centerRight,
            //     colors: [Color(0xb71c1c), Color(0xfff7892b)])
            ),
        child: Text(
          'Login',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: new Container(
          padding:
              EdgeInsets.only(top: 120, right: 30.0, left: 30.0, bottom: 60.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      radius: 60.0,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    new Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "This field is Required";
                        }
                        return value;
                      },
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        hintText: 'Enter you name',
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is required';
                        }

                        return null;
                      },
                      obscureText: _isHidden,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(Icons.visibility_off),
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        hintText: 'Password',
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "forgot password?",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _submitButton(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text("Don't have an account?"),
                            SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignupPage()));
                                },
                                child: Container(
                                  child: new Text(
                                    "SIGN UP",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
