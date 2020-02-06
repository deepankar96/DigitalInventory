import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Image_upload extends StatefulWidget {
  File imageFile;
  Image_upload({Key key,this.imageFile}) : super(key:key);

  @override
  _Image_uploadState createState() => _Image_uploadState(imageFile);
}

class _Image_uploadState extends State<Image_upload> {


SharedPreferences sharedPreferences;
double _direction;
File imageFile;
_Image_uploadState(this.imageFile);
double latitude,longitude;
String username;  
final _controller = TextEditingController();
String description = "";
final _controller1 = TextEditingController();
String location = "";
int heading;
TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);




  

@override
void initState() { 
  super.initState();
  _getDirection();
  _getLocation();
  _getUserName();
}


_getLocation() async{
  
  var currentLocation = await Location().getLocation();
  this.setState((){
    latitude=currentLocation.latitude;
    longitude=currentLocation.longitude;
  });
  
}

_getDirection() async{
  FlutterCompass.events.listen((double direction) {
      if(_direction == null){
      setState(() {
        _direction = direction;
      });
      }
    });
}

_getHeading() async{
  if(_direction>=0 && _direction<45){
    this.setState((){
      heading = 1;
    });
  }
  else if(_direction>=45 && _direction<90){
    this.setState((){
      heading = 2;
    });
  }
  else if(_direction>=90 && _direction<135){
    this.setState((){
      heading = 3;
    });
  }
  else if(_direction>=135 && _direction<180){
    this.setState((){
      heading = 4;
    });
  }
  else if(_direction>=180 && _direction<225){
    this.setState((){
      heading = 5;
    });
  }
  else if(_direction>=225 && _direction<270){
    this.setState((){
      heading = 6;
    });
  }
  else if(_direction>=270 && _direction<315){
    this.setState((){
      heading = 7;
    });
  }
  else if(_direction>=315 && _direction<360){
    this.setState((){
      heading = 8;
    });
  }
}

 _getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = (prefs.getString('token')??'');
    });
 }
Future upload(File imageFile) async{
/*  
  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();
  var uri = Uri.parse("https://xipaarsolutions.com/SpotoGraphy/upload_image.php");
  
  var request = new http.MultipartRequest("POST", uri);
  var multiPartFile = new http.MultipartFile("image", stream, length,filename: basename(imageFile.path));
  request.files.add(multiPartFile);

  var response = await request.send();
  
  final res = await response.stream.bytesToString();
  print(res);
  print(response.statusCode);
  
*/ 
  

final String target ='http://192.168.43.52/test.php';
if (imageFile == null) return;
   String base64Image = base64Encode(imageFile.readAsBytesSync());
   String fileName = location.toString()+"+"+heading.toString()+"+"+username.toString();

   http.post(target, body: {
     "image": base64Image,
     "name": fileName.toString(),
     "latitude":latitude.toString(),
     "longitude":longitude.toString(),
     "description":description.toString(),
     "location":location.toString(),
     "username":username.toString(),
     "heading":heading.toString(),
   }).then((res) {
     print(res.statusCode);
     print(res.body);
     Fluttertoast.showToast(
                          msg: "Image Upload Successfull.",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
   }).catchError((err) {
     print(err);
   });

}



@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
        backgroundColor: Colors.blue,
        ),
      body: SingleChildScrollView(
              child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  widget.imageFile == null ? Text('No Image Selected',style: style,) : Image.file(widget.imageFile,height: 240,width: 240,),                
                  Container(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Description",
                      ),
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                  Container(
                    child: TextField(
                      controller: _controller1,
                      decoration: InputDecoration(
                        hintText: "Location",
                      ),
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0xff01A0C7),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () {
                      setState(() {
                            description = _controller.text;
                            location = _controller1.text;
                          });
                          if(location.length > 0){
                          _getHeading();
                          upload(widget.imageFile);
                          Navigator.pop(context);
                          }
                          else{
                             Fluttertoast.showToast(
                            msg: "PLease enter location.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                          }
                    },
                    child: Text("Upload",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),               
                ],
              ),
            ),
          ),
      ),
      );
  }  
}


  

