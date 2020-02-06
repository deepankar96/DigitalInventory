
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


class carausal extends StatefulWidget {
  final String location,username;

  const carausal({Key key, this.location,this.username}): super(key: key);
  

  @override
  _carausalState createState() => _carausalState();
}

class _carausalState extends State<carausal> {



  Future<List<ImageDetails>> _getImage(String newlocation) async{
          final String target ='http://192.168.43.52/user_feed1.php';
          Map userdata = {
              'user': widget.username,
              'location': newlocation,
                };
          var data = await http.post(target,body: userdata);
          var jsonData  = jsonDecode(data.body);
          List<ImageDetails> images = [];
          for(var u in jsonData){
            ImageDetails image = ImageDetails(u["name"],u["latitude"],u["longitude"],u["description"],u["location"],u["heading"]);
            images.add(image);
          }
          //print(images.length);
          return images;
        }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location),
        backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
                future: _getImage(widget.location),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.data == null){
                    return Text("Data not recieved");
                  }
                  else{
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 600,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 420,
                              child: Card(
                                child: Wrap(
                                  children: <Widget>[
                                    Image.network('http://192.168.43.52/'+snapshot.data[index].name,
                                    width: 450,
                                    height: 550,
                                    ),
                                    ListTile(
                                      title: Text("Location: "+snapshot.data[index].location.toString()),
                                      subtitle: Text(_showdirection(snapshot.data[index].heading.toString())),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            /*Image.network(
                              'http://192.168.43.52/'+snapshot.data[index].name
                            ),
                            Text(snapshot.data[index].name),*/
                            SizedBox(height: 20,)
                          ],
                        ),
                      );
                    },
                  );
                  }
                }
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