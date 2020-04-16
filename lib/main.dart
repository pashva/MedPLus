import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:medplus/AnimatedBackground.dart';
import 'package:medplus/myorders.dart';
import 'package:medplus/ordermodel.dart';
import 'package:medplus/searchingandfiltering.dart';
import 'package:medplus/splash.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medplus/customui.dart';
import 'package:medplus/listmodel.dart';
import 'package:medplus/parabuilder.dart';
import 'cart.dart';
import 'cartmodel.dart';
import 'package:http/http.dart' as http;
import 'counterbloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
 ));
    return ChangeNotifierProvider(
      create: (context) => cbloc(),
      child: MaterialApp(
        
        debugShowCheckedModeBanner: false,
        title: 'MedPlus',
        home: splash(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  List a;
  List b;
  List c;
  List d;
  String token;
  String email;
  HomePage(this.a, this.b, this.c, this.d, this.token, this.email);
  @override
  _HomePageState createState() => _HomePageState();
}

List<cart> cartlist = [];
bool creamtoggle = false;
bool paratoggle = true;
bool antitoggle = false;
bool coldtoggle = false;
bool coughtoggle = false;
bool headtoggle = false;

class _HomePageState extends State<HomePage> {
  bool loading = false;

  Future<List> getorders() async {
    List<Order> x = [];

    final String url = "https://d5467778.ngrok.io/list_order";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({"username": widget.email}));

    var res = json.decode(response.body);
    for (int i = 0; i < res[0]; i++) {
      x.add(Order(
          cost: res[1][i]["cost"],
          items: res[1][i]["items"],
          paymenttype: res[1][i]["payment-type"],
          status: res[1][i]["status"]));
    }

    return x;
  }

  Future<List> getList1() async {
    List<med> x = [];

    final String url = "https://d5467778.ngrok.io/cat_call";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({"category": "paracetamol"}));

    var res = json.decode(response.body);
    for (int i = 0; i < res[0]; i++) {
      x.add(med(
          name: res[1][i]["name"],
          cost: res[1][i]["cost"],
          quantity: res[1][i]["quantity"]));
    }

    return x;
  }

  Future<List> getList2() async {
    List<med> x = [];

    final String url = "https://d5467778.ngrok.io/cat_call";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({"category": "creams"}));

    var res = json.decode(response.body);
    for (int i = 0; i < res[0]; i++) {
      x.add(med(
          name: res[1][i]["name"],
          cost: res[1][i]["cost"],
          quantity: res[1][i]["quantity"]));
    }
    return x;
  }

  Future<List> getlistallmeds() async {
    List<med> x = [];

    final String url = "https://d5467778.ngrok.io/all_meds";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({}));

    var res = json.decode(response.body);
    for (int i = 0; i < res[0]; i++) {
      x.add(med(
          name: res[1][i]["name"],
          cost: res[1][i]["cost"],
          quantity: res[1][i]["quantity"]));
    }
    return x;
  }

  Future<List> getList3() async {
    List<med> x = [];

    final String url = "https://d5467778.ngrok.io/cat_call";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        },
        body: json.encode({"category": "antibiotics"}));

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
    int counter = Provider.of<cbloc>(context).counter;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: loading
          ? Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Background(),
                
                
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      CustomAppBar(counter, widget.token, widget.email),
                      SizedBox(
                        height: 0.0005 * height,
                      ),
                      Container(
                        height: 0.25 * height,
                        child: Padding(
                          padding: EdgeInsets.all(0.0093 * height),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 0.04866 * width),
                                  padding: EdgeInsets.fromLTRB(
                                      0.011 * height,
                                      0.011 * height,
                                      0.011 * height,
                                      0.023 * height),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: paratoggle
                                        ? Colors.white70
                                        : Colors.white,
                                    border: Border.all(
                                        color: paratoggle
                                            ? Colors.transparent
                                            : Colors.grey[200],
                                        width: 1.5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            EdgeInsets.all(0.023 * height),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: paratoggle
                                                    ? Colors.transparent
                                                    : Colors.grey[200],
                                                width: 1.5)),
                                        child: Icon(
                                          Icons.local_hospital,
                                          color: Colors.black,
                                          size: 0.0352 * height,
                                        ),
                                      ),
                                      SizedBox(height: 0.0117 * height),
                                      Text(
                                        "Paracetamol",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 0.0176 * height),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0,
                                            0.007 * height,
                                            0,
                                            0.0117 * height),
                                        width: 1.5,
                                        height: 0.0176 * height,
                                        color: Colors.black26,
                                      ),
                                      Text(
                                        widget.a.length.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  setState(() {
                                    if (antitoggle ||
                                        coldtoggle ||
                                        headtoggle ||
                                        coughtoggle ||
                                        creamtoggle) {
                                      creamtoggle = false;
                                      antitoggle = false;
                                      paratoggle = true;
                                      coldtoggle = false;
                                      coughtoggle = false;
                                      headtoggle = false;
                                    } else {}
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 0.04866 * width),
                                  padding: EdgeInsets.fromLTRB(
                                      0.011 * height,
                                      0.011 * height,
                                      0.011 * height,
                                      0.023 * height),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: creamtoggle
                                        ? Colors.white70
                                        : Colors.white,
                                    border: Border.all(
                                        color: creamtoggle
                                            ? Colors.transparent
                                            : Colors.grey[200],
                                        width: 1.5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: creamtoggle
                                                    ? Colors.transparent
                                                    : Colors.grey[200],
                                                width: 1.5)),
                                        child: Icon(
                                          Icons.local_hospital,
                                          color: Colors.black,
                                          size: 0.0352 * height,
                                        ),
                                      ),
                                      SizedBox(height: 0.0117 * height),
                                      Text(
                                        "Cream",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 6, 0, 10),
                                        width: 1.5,
                                        height: 0.0173 * height,
                                        color: Colors.black26,
                                      ),
                                      Text(
                                        widget.b.length.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  setState(() {
                                    if (antitoggle ||
                                        coldtoggle ||
                                        headtoggle ||
                                        coughtoggle ||
                                        paratoggle) {
                                      creamtoggle = true;
                                      antitoggle = false;
                                      paratoggle = false;
                                      coldtoggle = false;
                                      coughtoggle = false;
                                      headtoggle = false;
                                    } else {}
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 0.04866 * width),
                                  padding: EdgeInsets.fromLTRB(
                                      0.011 * height,
                                      0.011 * height,
                                      0.011 * height,
                                      0.023 * height),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: antitoggle
                                        ? Colors.white70
                                        : Colors.white,
                                    border: Border.all(
                                        color: antitoggle
                                            ? Colors.transparent
                                            : Colors.grey[200],
                                        width: 1.5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: antitoggle
                                                    ? Colors.transparent
                                                    : Colors.grey[200],
                                                width: 1.5)),
                                        child: Icon(
                                          Icons.local_hospital,
                                          color: Colors.black,
                                          size: 0.0352 * height,
                                        ),
                                      ),
                                      SizedBox(height: 0.0117 * height),
                                      Text(
                                        "Antibiotics",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0,
                                            0.007 * height,
                                            0,
                                            0.0117 * height),
                                        width: 1.5,
                                        height: 15,
                                        color: Colors.black26,
                                      ),
                                      Text(
                                        widget.c.length.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  setState(() {
                                    if (paratoggle ||
                                        coldtoggle ||
                                        headtoggle ||
                                        coughtoggle ||
                                        creamtoggle) {
                                      creamtoggle = false;
                                      antitoggle = true;
                                      paratoggle = false;
                                      coldtoggle = false;
                                      coughtoggle = false;
                                      headtoggle = false;
                                    } else {}
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 0.04866 * width),
                                  padding: EdgeInsets.fromLTRB(
                                      0.011 * height,
                                      0.011 * height,
                                      0.011 * height,
                                      0.023 * height),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: headtoggle
                                        ? Colors.white70
                                        : Colors.white,
                                    border: Border.all(
                                        color: headtoggle
                                            ? Colors.transparent
                                            : Colors.grey[200],
                                        width: 1.5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: headtoggle
                                                    ? Colors.transparent
                                                    : Colors.grey[200],
                                                width: 1.5)),
                                        child: Icon(
                                          Icons.local_hospital,
                                          color: Colors.black,
                                          size: 0.0352 * height,
                                        ),
                                      ),
                                      SizedBox(height: 0.0117 * height),
                                      Text(
                                        "Inhalants",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0,
                                            0.007 * height,
                                            0,
                                            0.0117 * height),
                                        width: 1.5,
                                        height: 15,
                                        color: Colors.black26,
                                      ),
                                      Text(
                                        widget.d.length.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    if (paratoggle ||
                                        coldtoggle ||
                                        antitoggle ||
                                        coughtoggle ||
                                        creamtoggle) {
                                      creamtoggle = false;
                                      antitoggle = false;
                                      paratoggle = false;
                                      coldtoggle = false;
                                      coughtoggle = false;
                                      headtoggle = true;
                                    } else {}
                                  });
                                },
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 0.5451 * height,
                        width: 0.8216 * height,
                        child: paratoggle
                            ? parabuilder(widget.a, cartlist)
                            : creamtoggle
                                ? parabuilder(widget.b, cartlist)
                                : antitoggle
                                    ? parabuilder(widget.c, cartlist)
                                    : headtoggle
                                        ? parabuilder(widget.d, cartlist)
                                        : Text(""),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.8967 * height),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          height: 0.0293 * 2 * height,
                          width: 0.0293 * 2 * height,
                          child: IconButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              List l = await getlistallmeds();
                              setState(() {
                                loading = false;
                              });

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => search(
                                            cartlist: cartlist,
                                            owaislist: l,
                                          )));
                            },
                            icon: Icon(
                              Icons.search,
                              size: 0.0293 * height,
                              color: Color(0xFFC4E0E5),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          height: 0.0293 * 2 * height,
                          width: 0.0293 * 2 * height,
                          child: IconButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              List<Order> userorders = await getorders();
                              setState(() {
                                loading = false;
                              });

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyOrders(
                                          myorders: userorders,
                                          email: widget.email)));
                            },
                            icon: Icon(
                              Icons.account_circle,
                              size: 0.0393 * height,
                              color: Color(0xFFC4E0E5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  CustomAppBar(this.counter, this.token, this.email);
  int counter;
  String token;
  String email;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      height: 0.0704 * height,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(0.0093 * height),
              child: GestureDetector(
                  onTap: () {
                    
                  },
                  child: Icon(
                    
                    Icons.menu,
                    size: 0.0352 * height,color: Colors.black,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                "MedPlus",
                style: TextStyle(
                    letterSpacing: 5.0,
                    fontSize: 0.04916 * height,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Signatra"),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white24,
                  ),
                  height: 30,
                  width: 30,
                  child: Center(
                      child: Text(
                    "${widget.counter}",
                    style: TextStyle(
                      fontSize: 21,
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.all(0.0093 * height),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Cart(
                                  
                                      cartlist: cartlist,
                                      token: widget.token,
                                      email: widget.email,
                                    )));
                      },
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                        size: 0.0352 * height,
                      )),
                ),
              ],
            )
          ]),
    );
  }
}
