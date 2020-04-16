import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:medplus/edit_profile.dart';
import 'package:medplus/gmaps.dart';

import 'ordermodel.dart';
import 'package:http/http.dart' as http;

class MyOrders extends StatefulWidget {
  String email;
  List<Order> myorders;
  MyOrders({this.myorders,this.email});
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  Firestore _firestore=Firestore.instance;
  String name="";
  int contact=0;
  String address="";
  double lat=0;
  double long=0;
  Future<void> getorderstat()async {
    DocumentSnapshot doc=await _firestore.collection("Location").document("delLoc").get();
    print(doc["distance"]);
    setState(() {
      lat=doc["latitude"];
      long=doc["longitude"];

    });
      
   
    
    
  }
  Future<void> get(String email)async {
    

    final String url = "https://d5467778.ngrok.io/get_profile";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({
          "username":email,
          

        }));

    var res = json.decode(response.body);
    setState(() {
      name=res["name"];
      contact=res["contact"];
      address=res["address"];
    });
    
    
    
  }
  
  
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: getorderstat,
          child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                
                color: Colors.white,
                onPressed: ()async{
                  await get(widget.email);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Editprofile(email: widget.email,name:name,contact:contact,address:address)));
                }, child: Text("Edit Profile",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent
                ),)),
            )
          ],
          centerTitle: true,
          title: Text("My Orders"),
          backgroundColor: Colors.lightBlueAccent,


        ),
        body: Stack(
          children: <Widget>[
            
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(60),bottomLeft: Radius.circular(60)),
                color: Colors.lightBlueAccent
              ),
              height: height*0.5,
              width: width,
            ),

            Container(
              height: height,
              width: width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.myorders.length,
                  itemBuilder: (BuildContext context,int index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 50,right: 50,bottom: 30),
                    child: Container(
                      
                      margin: EdgeInsets.only(top: 20),
                      height: 300,
                      width: width*0.7,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        
                        elevation: 20,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("Order:",style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 0.02347*height
                                ),),
                                FlatButton(
                                  color: Colors.lightBlueAccent,
                                    onPressed: ()async {
                                      showDialog(context: context
                                          ,barrierDismissible: false,
                                        builder: (BuildContext context){
                                        return AlertDialog(
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Close'),
                                              onPressed: () {

                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                          title: Text(widget.myorders[index].items),

                                        );


                                      }
                                      );


                                   }, child: Text("Items List",style: TextStyle(
                                  color: Colors.white
                                ),)),
                                
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              Text("Cost: Rs "+widget.myorders[index].cost.toString(),style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20

                                ),)
                            ],),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              Text("Status: ",style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20

                                ),),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(top: BorderSide(color: Colors.lightBlueAccent),bottom:  BorderSide(color: Colors.lightBlueAccent),right: BorderSide(color: Colors.lightBlueAccent),left: BorderSide(color: Colors.lightBlueAccent))
                                ),
                                child: Text(widget.myorders[index].status==0?"Not Delivered":"Delivered",style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17

                                  ),),
                              ),
                              widget.myorders[index].status==0?Icon(Icons.cancel,color: Colors.red,):Icon(Icons.check_circle,color: Colors.green,)
                              
                                
                            ],
                            ),
                            SizedBox(
                              height: 20,
                            )
                            ,
                            Row(children: <Widget>[
                                   Text("Payment Type: "+widget.myorders[index].paymenttype,style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15
                                ),)


                                ],),
                                SizedBox(
                                  height: 15,

                                ),
                                
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  
                                  child: IconButton(
                                    
                                    
                                    
                                    icon: Icon(Icons.location_on,color: Colors.white,size: 25,), onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MapSample()));
                                  }),
                                )
                                
                            
                            


                          ],
                        ),

                      ),
                    ),
                  );
                  }
              ),
            ),
           
          ],

        )),
    );
  }
}
