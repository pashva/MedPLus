import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:medplus/loginpage.dart';

class Reset extends StatefulWidget {
  String email;
  Reset({this.email});
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  Future<bool> reset(String email,String password)async {
    

    final String url = "https://d5467778.ngrok.io/forget_password";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({
          "username":email,
          "password":password

        }));

    bool res = json.decode(response.body);
    return res;
    
    
  }
  TextEditingController passcontroller = TextEditingController();
  TextEditingController confirmpasscontroller = TextEditingController();
  String password = "";
  String confirmpassword = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Reset",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300])),
                  color: Colors.white),
              child: TextField(
                controller: passcontroller,
                obscureText: true,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                    hintText: "Password"),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300])),
                  color: Colors.white),
              child: TextField(
                controller: confirmpasscontroller,
                obscureText: true,
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (value) {
                  confirmpassword = value;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                    hintText: "Confirm Password"),
              ),
            ),
            FlatButton(
              color: Colors.white,
              onPressed: ()async{
              
              if(passcontroller.text==confirmpasscontroller.text){
                print(passcontroller.text);
                print(widget.email);
                bool done=await reset(widget.email,passcontroller.text);
                if(done){
                  Fluttertoast.showToast(msg: "Password Reset Successful");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                }else{
                  Fluttertoast.showToast(msg: "Error");
                  Navigator.pop(context);
                  Navigator.pop(context);
                }

              }else{
                Fluttertoast.showToast(msg: "Passwords dont match");
              }
              

            }, child: Icon(Icons.edit,color: Color.fromRGBO(3, 9, 23, 1),))
          ],
        ),
      ),
    );
  }
}
