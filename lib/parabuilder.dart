import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medplus/cartmodel.dart';
import 'package:medplus/counterbloc.dart';
import 'package:medplus/main.dart';
import 'package:provider/provider.dart';


// ignore: camel_case_types
class parabuilder extends StatefulWidget {
  parabuilder(this.givenbuillist,this.cartlist);
  final List givenbuillist;
  final List cartlist;

  @override
  _parabuilderState createState() => _parabuilderState();
}
class _parabuilderState extends State<parabuilder> {

  @override
  Widget build(BuildContext context) {
    int counter= Provider.of<cbloc>(context).counter;
    return  ListView.builder(
          itemCount: widget.givenbuillist.length,
          itemBuilder: (BuildContext context ,int index){
            return Card(
              elevation: 6,
              child: Container(
                height: 100,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(widget.givenbuillist[index].name.toString(),style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700
                                ),),
                                width: 200,
                                height: 50,
                              ),
                              Text("Availability:"+widget.givenbuillist[index].quantity.toString()),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Rs"+widget.givenbuillist[index].cost.toString()),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF4AC29A),
                            ),

                            child: IconButton(

                              icon: Icon(Icons.add,color: Colors.white,size: 25,),
                              onPressed: ()async {

                                  await cartlist.add(cart(name:widget.givenbuillist[index].name,cost:widget.givenbuillist[index].cost));

                                  Fluttertoast.showToast(
                                      msg: "Item added to cart successfully",
                                      
                                  );
                                  Provider.of<cbloc>(context, listen: false).incrementcounter();
                              },
                            ),
                          )

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            );


          }
    );
  }
}
