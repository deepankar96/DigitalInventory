import 'package:flutter/material.dart';
import 'main.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class changepassword extends StatefulWidget {
  changepassword({Key key}) : super(key: key);

  @override
  _changepasswordState createState() => _changepasswordState();
}

class _changepasswordState extends State<changepassword> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _emailConroller = TextEditingController();
  final _oldpasswordConroller = TextEditingController();
  final _newpasswordConroller = TextEditingController();
  



  _changePassword(String email,oldpass,newpass) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'oldpassword': oldpass,
      'newpassword':newpass,
    };
    final String target ='https://xipaarsolutions.com/SpotoGraphy/changepassword.php';
    var response = await http.post(target, body: data);
    if(response.statusCode == 200) {
      if(response.body != null) {
        if(response.body.toString() == '1'){
          Fluttertoast.showToast(
                          msg: "Password Changed. Please login. ",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
        sharedPreferences.clear();
        sharedPreferences.commit();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
      }
      else if(response.body.toString() == '2'){
          Fluttertoast.showToast(
                          msg: "Old Password identical to new password",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
      }
      else if(response.body.toString()=='3'){
          Fluttertoast.showToast(
                          msg: "Old Password Does not match",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
      }
      else if(response.body.toString() == '4'){
          Fluttertoast.showToast(
                          msg: "Internal Error. Please try again",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
      }
      else if(response.body.toString() == '5'){
          Fluttertoast.showToast(
                          msg: "New Password must be atleast 6 characters long.",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
      }
      }
    }
    else {
      setState(() {
        print("False 2");
      });
      //print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {

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

    final oldpasswordField = TextField(
          controller: _oldpasswordConroller,
          obscureText: true,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Old Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );

    final newpasswordField = TextField(
          controller: _newpasswordConroller,
          obscureText: true,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "New Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final changepasswordbutton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              _changePassword(_emailConroller.text,_oldpasswordConroller.text,_newpasswordConroller.text);
            },
            child: Text("Change Password",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );


    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: Colors.blue,
        ),
      body: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    oldpasswordField,
                    SizedBox(
                      height: 25.0,
                    ),
                    newpasswordField,
                    SizedBox(
                      height: 45.0,
                    ),
                    changepasswordbutton,
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