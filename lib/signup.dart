import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:smart_agriculture/Dashboard.dart';

class SignupPage extends StatefulWidget {
  
  @override
  _SignupPageState createState() => _SignupPageState();
}
final TextEditingController _emailcontroller = new TextEditingController();
final TextEditingController _namecontroller =new TextEditingController();
final TextEditingController _mobilecontroller =new TextEditingController();
final TextEditingController _passwordcontroller=new TextEditingController();
String username;
String email;
var password;
var mobile;

var items = ['belgavi,karnataka', 'bengluru,karnataka'];
class _SignupPageState extends State<SignupPage> {
   final _formKey = GlobalKey<FormState>();
   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    void signUp(String username,String email,String mobile,String password ) async{
   var data =jsonEncode({"Username":username,});
     var response = await http.post(
      Uri.http('192.168.43.242:5000', 'register'),
      body: data,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final result=jsonDecode(response.body);
    if(result['result']['status']==1){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            'registered  Successfully',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
       Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    }
    else{
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            'Fail to register',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

 }
 
  @override
  Widget build(BuildContext context) {


 Widget _submitButton() {
    return GestureDetector(
      onTap: () =>{
        if (_formKey.currentState.validate()){
          username=_namecontroller.text,
          email=_emailcontroller.text,
          mobile=_mobilecontroller.text,
          password=_passwordcontroller,

          signUp(username,email,mobile,password),
        }
        else{
          print("Form is not validated")
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
      
        decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.all(Radius.circular(23.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            // gradient: LinearGradient(
            //     begin: Alignment.centerLeft,
            //     end: Alignment.centerRight,
                // colors: [Color(0xfffbb448), Color(0xfff7892b)])
                ),
        child: Text(
          'Sign up',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }


    Widget _title() {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: 'S',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 60)),
          TextSpan(
              text: 'ign', style: TextStyle(color: Colors.black, fontSize: 40)),
          TextSpan(
            text: 'u',
            style: TextStyle(
              // 0xffe46b10
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 40),
          ),
          TextSpan(
            text: 'p',
            style: TextStyle(color:Colors.greenAccent, fontSize: 30),
          ),
          TextSpan(
            text: '?',
            style: TextStyle(color:Colors.greenAccent, fontSize: 50),
          ),
          TextSpan(
            text: '?',
            style: TextStyle(color:Colors.greenAccent, fontSize: 30),
          ),
          TextSpan(
            text: '?',
            style: TextStyle(color:Colors.greenAccent, fontSize: 20),
          ),
        ]),
      );
    }

    return Scaffold(
        key: _scaffoldKey,
      body: Container(
                    padding:
              EdgeInsets.only(top: 100, right: 20.0, left: 20.0, bottom: 60.0),
              child:Form(
                key: _formKey,
            child:SingleChildScrollView(
               child: Column(
                children: [
                  
                  _title(),
                   SizedBox(
                  height: 30,
                ),
                TextField(
                 keyboardType: TextInputType.name,
                 controller: _namecontroller,
                 decoration: const InputDecoration(
                   prefixIcon: Icon(Icons.person),
                   fillColor: Color(0xfff3f3f4),
                        filled: true,
                        border: InputBorder.none,
                        hintText:"Enter your name",
                        labelText: "Your Good name"
                 ),
                 
                ),
                 SizedBox(
                  height: 30,
                ),
                TextField(
                 keyboardType: TextInputType.emailAddress,
                 controller: _emailcontroller,
                 decoration: const InputDecoration(
                   prefixIcon: Icon(Icons.email),
                   fillColor: Color(0xfff3f3f4),
                        filled: true,
                        border: InputBorder.none,
                        hintText: "email address",
                        labelText: "Email"
                 ),
                 
                ),
                SizedBox(
                  height: 30,
                ),
                 TextField(
                 keyboardType: TextInputType.phone,
                 controller: _mobilecontroller,
                 decoration: const InputDecoration(
                   prefixIcon: Icon(Icons.phone),
                   fillColor: Color(0xfff3f3f4),
                        filled: true,
                        border: InputBorder.none,
                        hintText: "mobile Number",
                        labelText: "Mobile Number",
                 ),
                 
                ),
                SizedBox(
                  height: 30,
                ),
                
                TextField(
                 keyboardType: TextInputType.visiblePassword,
                 controller: _passwordcontroller,
                 decoration: const InputDecoration(
                   prefixIcon: Icon(Icons.lock),
                   fillColor: Color(0xfff3f3f4),
                        filled: true,
                         border: InputBorder.none,
                         hintText: "password",
                         labelText: "password",

                 ),
                 
                ),
                  
                    SizedBox(height: 30,),
                _submitButton(),
                

                ],
              ),
            ),
      ),
      )
          
      
      
    );
  }
}
