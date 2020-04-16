import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'cartmodel.dart';
import 'counterbloc.dart';
import 'package:http/http.dart' as http;
import 'listmodel.dart';

class search extends StatefulWidget {
  List<cart> cartlist;
  List<med> owaislist;
  search({this.cartlist, this.owaislist});

  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  Future<List> searchlist(String name) async {
    List<med> x = [];

    final String url = "https://d5467778.ngrok.io/search";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({"name": name}));

    var res = json.decode(response.body);
    for (int i = 0; i < res[0]; i++) {
      x.add(med(
          name: res[1][i]["name"],
          cost: res[1][i]["cost"],
          quantity: res[1][i]["quantity"]));
    }
    return x;
  }

  @override
  Widget build(BuildContext context) {
    String name;
    List<med> filteredmeds = widget.owaislist;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightgreen,
          title: Text("Search"),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Enter the medicine name"),
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        List l = await searchlist(name);
                        setState(() {
                          widget.owaislist = l;
                        });
                      })
                ],
              ),
              Container(
                height: 640,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: filteredmeds.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  filteredmeds[index].name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "Cost:" + filteredmeds[index].cost.toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "Available:" +
                                      filteredmeds[index].quantity.toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.lightBlue[200],
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                      size: 25,
                                    ),
                                    onPressed: () async {
                                      await widget.cartlist.add(cart(
                                          name: filteredmeds[index].name,
                                          cost: filteredmeds[index].cost));

                                      Fluttertoast.showToast(
                                          msg:
                                              "Item added to cart successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: 1,
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Provider.of<cbloc>(context, listen: false)
                                          .incrementcounter();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
