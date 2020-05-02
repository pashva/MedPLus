
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer2/mailer.dart';
import 'package:medplus/main.dart';

import 'package:http/http.dart' as http;
import 'package:medplus/resetpage.dart';
import 'package:medplus/signup.dart';

import 'listmodel.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String paraAmount;
  bool loading=false;

  String status;

  String email;

  String password;
  Future<bool> verify(String email)async {
    

    final String url = "https://owaismedplus.herokuapp.com/check_user";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({
          "username":email

        }));

    bool res = json.decode(response.body);
    return res;
    
    
  }
  
  Future<List> getlist4()async {
    List<med> x=[];

    final String url = "https://owaismedplus.herokuapp.com/cat_call";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({
          "category": "inhalants"

        }));

    var res = json.decode(response.body);
    for(int i=0;i<res[0];i++){
      x.add(med(name: res[1][i]["name"],cost: res[1][i]["cost"],quantity: res[1][i]["quantity"]));

    }
    return x;

  }

  Future<List> getList1()async {
    List<med> x=[];

    final String url = "https://owaismedplus.herokuapp.com/cat_call";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({
          "category": "paracetamol"

        }));

    var res = json.decode(response.body);
    for(int i=0;i<res[0];i++){
      x.add(med(name: res[1][i]["name"],cost: res[1][i]["cost"],quantity: res[1][i]["quantity"]));

    }

    return x;

  }
  Future<List> getList2()async {
    List<med> x=[];

    final String url = "https://owaismedplus.herokuapp.com/cat_call";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({
          "category": "creams"

        }));

    var res = json.decode(response.body);
    for(int i=0;i<res[0];i++){
      x.add(med(name: res[1][i]["name"],cost: res[1][i]["cost"],quantity: res[1][i]["quantity"]));

    }
    return x;

  }
  Future<List> getList3()async {
    List<med> x=[];

    final String url = "https://owaismedplus.herokuapp.com/cat_call";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({
          "category": "antibiotics"

        }));

    var res = json.decode(response.body);
    for(int i=0;i<res[0];i++){
      x.add(med(name: res[1][i]["name"],cost: res[1][i]["cost"],quantity: res[1][i]["quantity"]));

    }
    return x;

  }


  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
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
          body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

             Text("Login",
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
            SizedBox(height: 20,),
            InkWell(
              splashColor: Colors.white,
              onTap: ()async {
                  if(email!=null && email!=""){

                   bool verification= await verify(email);
                   if(verification){
                            var rndnumber="";
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
                             ..text = '?'
                             ..html = '<h1>Invoice</h1><p>OTP</p>';

                           // Email it.
                           emailTransport.send(envelope)
                               .then((envelope) {
                             print("sent");
                           })
                               .catchError((e) => print('Error occurred: $e'));
                      
                      String votp="";
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
                                  print("$email");

                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Reset(email: email,)));
                                  }else{
                                    Fluttertoast.showToast(msg: "Invalid otp");

                                  }
                                  




                                  

                              },
                            ),
                          ],
                        );
                      },
                    );

                   }else{
                     Fluttertoast.showToast(msg: "Email does not exist");
                   }
                   
                    

                  }else{
                    Fluttertoast.showToast(msg: "Email is empty");
                  }
                


              },
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("Forget Password?",style: TextStyle(
                letterSpacing: 1.7,
                color: Colors.white,
                fontWeight: FontWeight.w600
              ),),
                          ),
            ),
            SizedBox(height: 20,),
            Center(
              child: InkWell(
                onTap: ()async {
                  setState(() {
                    loading=true;
                  });
                  final String url = "https://owaismedplus.herokuapp.com/login";
                  var response = await http.post(url,
                      headers: {
                        "Accept": "application/json",
                        "Content-type": "application/json",
                      },
                      body: json.encode({
                        "username": email,
                        "password": password,
                      }));

                  var res = json.decode(response.body);
                  String token=res["access_token"];




                  if(response.statusCode==200){
                    List a=await getList1();
                    List b=await getList2();
                    List c=await getList3();
                    List d=await getlist4();


                    setState(() {
                      loading=false;
                    });


                    await Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(a,b,c,d,token,email)));
                  }
                  else{
                    setState(() {
                      loading=false;
                    });
                    Fluttertoast.showToast(
                        msg: "Invalid user",
                        
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
                  child: Center(child: Text("Login", style: TextStyle(color: Colors.white.withOpacity(.7)),)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: InkWell(
                onTap: ()async {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));

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
    );
  }
}