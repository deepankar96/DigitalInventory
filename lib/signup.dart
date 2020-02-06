import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);


  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _firstNameConroller = TextEditingController();
  final _lastNameconroller = TextEditingController();
  final _emailConroller = TextEditingController();
  final _passwordConroller = TextEditingController();
  String id;
  int route = 0;

  signUp(String firstname,lastname, email, pass) async {
    if(firstname == null || lastname == null || email == null || pass ==null || pass.toString().length <7 || !email.contains("@")|| !email.contains(".com")){
      
    }
    else{
    Map data = {
      'firstname' : firstname,
      'lastname' : lastname,
      'email': email,
      'password': pass
    };
    final String target ='https://xipaarsolutions.com/SpotoGraphy/signup.php';
    var response = await http.post(target, body: data);
    if(response.statusCode == 200) {
      if(response.body!=null){
         this.setState((){
          route = 1;
          id = response.body.toString();
         });
      }    
    }
    }
  }





  @override
  Widget build(BuildContext context) {


    final firstNameField = TextField(
          controller: _firstNameConroller,
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "First Name",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );

    final lastNameField = TextField(
          controller: _lastNameconroller,
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Last Name",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );

    final emailField = TextField(
          controller: _emailConroller,
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );

    final passwordField = TextField(
          controller: _passwordConroller,
          obscureText: true,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
    
    final signupButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              signUp(_firstNameConroller.text, _lastNameconroller.text, _emailConroller.text, _passwordConroller.text);
              if (route == 0){
                Fluttertoast.showToast(
                          msg: "Field Cannot be empty.\nEnter Valid Email.\nPassword length must be atleast 6 characters.",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
              }
              else if(route == 1){
              Fluttertoast.showToast(
                          msg: "Sign up Successfull.",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
              }
            },
            child: Text("Sign Up",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

     return Scaffold(
          body: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 25.0),
                    firstNameField,
                    SizedBox(height: 25.0),
                    lastNameField,
                    SizedBox(height: 25.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 65.0,
                    ),
                    signupButton,
                    SizedBox(
                      height: 15.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        );



    
  }
}