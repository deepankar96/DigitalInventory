import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'image_upload.dart';
import 'dart:io';
import 'changepassword.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'carausal.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Spotography",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
        accentColor: Colors.blue,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  
  SharedPreferences sharedPreferences;
  String username = "";
  File imageFile;

  _getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = (prefs.getString('token')??'');
    });
  }

  _openCamera() async{
    var picture = await ImagePicker.pickImage(
      source: ImageSource.camera
    );
    if(picture != null){
    this.setState((){
      imageFile = picture;
      Navigator.push(context, 
                  new MaterialPageRoute(
                    builder: (context) => Image_upload(imageFile: imageFile,),
                  ));
    });
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _getUserName();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }
  }

  Future<List<String>> _getLocation() async{
    final String target ='http://192.168.43.52/user_locations.php';
     Map userdata = {
              'user': username,
                };
          var data = await http.post(target,body: userdata);
          print(data.body);
          var jsonData  = jsonDecode(data.body);
          List<String> location = [];
          for (var u in jsonData){
            String location_1 = u['location'].toString();
            location.add(location_1);
          }
      //print(location.length);
      return location;

  }
  


  Future<List<ImageDetails>> _getImage(String newlocation) async{
          final String target ='http://192.168.43.52/user_feed.php';
          Map userdata = {
              'user': username,
              'location': newlocation,
                };
          var data = await http.post(target,body: userdata);
          //print(data.body.toString());
          var jsonData  = jsonDecode(data.body);
          List<ImageDetails> images = [];
          for(var u in jsonData){
            ImageDetails image = ImageDetails(u["name"],u["latitude"],u["longitude"],u["description"],u["location"],u["heading"]);
            images.add(image);
          }
          //print(images.length);
          return images;
        }

      
  


  @override
  Widget build(BuildContext context) {

    _showdirection(String heading){
        if(heading == "1"){
          return "North";
        }
        else if(heading == "2"){
          return "North-East";
        }
        else if(heading == "3"){
          return "East";
        }
        else if(heading == "4"){
          return "South-East";
        }
        else if(heading == "5"){
          return "South";
        }
        else if(heading == "8"){
          return "North-West";
        }
        else if(heading == "6"){
          return "South-West";
        }
        else if(heading == "7"){
          return "West";
        }
      }




    buildWidget(String loc){
      return Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              Navigator.push(context, 
                  new MaterialPageRoute(
                    builder: (context) => carausal(location: loc,username:username),
                  ));
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    loc,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            )
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Spotography", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            iconSize: 32,
            icon: Icon(Icons.camera_alt),
            onPressed: (){
              _openCamera(); 
            },
          )
        ],
      ),
      body:FutureBuilder(
        future: _getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null){
                    return Text("No Contributions");
                  }
          else{
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index){
              return Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  buildWidget(snapshot.data[index]),
                ],
              );
            }
          );}
        }
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  Image.asset(
                          "images/profile.png",
                          width: 100,
                          height: 100,
                        ),
                
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            FlatButton(
              onPressed: () {
                
              },
              child: Text("Username: "+username),
              ),
            FlatButton(
              onPressed: () {
                Navigator.push(context, 
                  new MaterialPageRoute(
                    builder: (context) => changepassword(),
                  ));
              },
              child: Text("Change Password",),
              ),
            FlatButton(
              onPressed: () {
                _googleSignIn.signOut();
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
              },
              child: Text("Log Out",),
          ),
          ],
        ),
      ),
    );
  }
}

class ImageDetails{

  final String name;
  final String latitude;
  final String longitude;
  final String description;
  final String location;
  final String heading;

  ImageDetails(this.name,this.latitude,this.longitude,this.description,this.location,this.heading);
}



//Testing git