
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer2/mailer.dart';


import 'package:http/http.dart' as http;


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool loading=false;

  String status;

  String email="";
  String password="";
  String address="";
  int phonenumber=0;
  String name="";
  bool passvalid=false;



  @override
  Widget build(BuildContext context) {
    
    return loading?Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/loginu.gif"),),
            CircularProgressIndicator(),
          ],
        )):Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),

              Text("Signup",
                style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                      child: TextField(
                        onChanged: (value){
                          name=value;

                        },
                        decoration: InputDecoration(

                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "Username"
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value){
                          email=value;

                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "Email"
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value){
                          phonenumber=int.parse(value);

                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "Phone number"
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]))
                      ),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (value){
                          address=value;

                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "Address"
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                      ),
                      child: TextField(
                        
                        obscureText: true,

                        onChanged: (value){
                          password=value;

                        },
                        decoration: InputDecoration(
                          
                          
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                            hintText: "Password"
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40,),
              Center(
                child: InkWell(
                  onTap: ()async {
                    if(password.isEmpty||email.isEmpty||name.isEmpty||phonenumber.toString().isEmpty||address.isEmpty){
                      Fluttertoast.showToast(msg: "Fill All Details");
                    }else{
                   
                    




                    setState(() {
                      loading=true;
                    });
                    var rndnumber="";
                    String votp="";
                    var rnd= new Random();
                    for (var i = 0; i < 6; i++) {
                      rndnumber = rndnumber + rnd.nextInt(9).toString();
                    }
                    var options = new GmailSmtpOptions()
                      ..username = 'noreply.medplus@gmail.com'
                      ..password = 'Medplus1234';

                    var emailTransport = new SmtpTransport(options);

                    // Create our mail/envelope.
                    var envelope = new Envelope()
                      ..from = 'foo@bar.com'
                      ..recipients.add('$email')
                      ..subject = '$rndnumber'
                      ..text = 'This is a cool email message. Whats up?'
                      ..html = '<h1>Invoice</h1><p>OTP</p>';

                    // Email it.
                    emailTransport.send(envelope)
                        .then((envelope) {
                      print("sent");
                    })
                        .catchError((e) => print('Error occurred: $e'));

                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Amazing'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Verify your otp :)'),
                                TextField(
                                  onChanged: (value){
                                    votp=value;
                                  },
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Verify'),
                              onPressed: () async {
                                if(votp==rndnumber){
                                  print("entered");
                                  final String url = "https://owaismedplus.herokuapp.com/sign_up";
                                  var response = await http.post(url,
                                      headers: {
                                        "Accept": "application/json",
                                        "Content-type": "application/json",
                                      },
                                      body: json.encode({
                                        "username":email,
                                        "password":password,
                                        "name":name,
                                        "address":address,
                                        "contact":phonenumber,


                                      }));
                                  print(response.statusCode);




                                  if(response.statusCode==201){

                                    setState(() {
                                      loading=false;
                                    });
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(
                                        msg: "Signup Successful",
                                        
                                    );



                                  }
                                  else{
                                    setState(() {
                                      loading=false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: "Signup failed",
                                        
                                    );
                                  }
                                  Navigator.pop(context);

                                }else{
                                  Fluttertoast.showToast(
                                      msg: "Invalid otp",
                                     
                                  );
                                }


                              },
                            ),
                          ],
                        );
                      },
                    );
                    }
                  },
                  child: Container(
                    width: 120,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue[800]
                    ),
                    child: Center(child: Text("Signup", style: TextStyle(color: Colors.white.withOpacity(.7)),)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}