import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mailer2/mailer.dart';

class Editprofile extends StatefulWidget {
  String email;
  String address;
  String name;
  int contact;
  Editprofile({this.email,this.address,this.name,this.contact});
  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  Future<bool> edit(String email,String username,int contact,String address)async {
    

    final String url = "https://owaismedplus.herokuapp.com/set_profile";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({
          "username":email,
          "name":username,
          "contact":contact,
          "address":address

        }));

    bool res = json.decode(response.body);
    return res;
    
    
  }
  TextEditingController contcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  @override
  void initState() {
    contcontroller.text=widget.contact.toString();
    usernamecontroller.text=widget.name;
    addresscontroller.text=widget.address;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Edit Profile",
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
                controller: usernamecontroller,
               
                keyboardType: TextInputType.text,
                
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                    hintText: "Name"),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300])),
                  color: Colors.white),
              child: TextField(
                controller: contcontroller,
                
                keyboardType: TextInputType.text,
                
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                    hintText: "Contact"),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300])),
                  color: Colors.white),
              child: TextField(
                controller: addresscontroller,
                
                keyboardType: TextInputType.text,
                
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                    hintText: "Address"),
              ),
            ),
           
            FlatButton(
              color: Colors.white,
              onPressed: ()async{
               bool a= await edit(widget.email, usernamecontroller.text,int.parse(contcontroller.text) ,addresscontroller.text);
              if(a){
                Fluttertoast.showToast(msg: "Successfully edited");
                Navigator.of(context).pop();
                var options = new GmailSmtpOptions()
    ..username = 'noreply.medplus@gmail.com'
    ..password = 'Medplus1234'; 
  var emailTransport = new SmtpTransport(options);

  
  var envelope = new Envelope()
    ..from = 'foo@bar.com'
    ..recipients.add('${widget.email}')
    ..bccRecipients.add('hidden@recipient.com')
    ..subject = 'Your Pofile is updated.'
    
    ..text = 'Your Pofile is updated.'
    ..html = '<h1>Profile Changes</h1><p>Your Pofile is updated.</p>';

  // Email it.
  emailTransport.send(envelope)
      .then((envelope) => print('Email sent!'))
      .catchError((e) => print('Error occurred: $e'));

              }else{
                Fluttertoast.showToast(msg: "Error");
                
              }
             

            }, child: Icon(Icons.edit,color: Color.fromRGBO(3, 9, 23, 1),))
          ],
        ),
      ),
    );
  }
}