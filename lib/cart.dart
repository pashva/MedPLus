import 'dart:convert';
import 'package:image/image.dart'as imgs;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medplus/AnimatedBackground.dart';

import 'package:medplus/main.dart';
import 'package:medplus/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'counterbloc.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  final token;
  final String email;
  Cart({this.cartlist, this.token, this.email});
  final List cartlist;
  @override
  _CartState createState() => _CartState();
}

String promo;

double d = 0.0;
String dropdownstr = "Cash on Delivery";

class _CartState extends State<Cart> {
  bool paid = false;
  Razorpay _razorpay;

  bool presuploaded = false;
  File file;
  bool loading = false;
  Future<void> prescriptionsend(String pres) async {
    final String url = "https://d5467778.ngrok.io/pres_order";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "JWT " + widget.token
        },
        body: json.encode({"username": widget.email, "pres": pres}));

    var res = json.decode(response.body);
  }

  Future<void> update(String medname) async {
    //https://owaismedplus.herokuapp.com/dec_stock
    final String url = "https://d5467778.ngrok.io/dec_stock";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "JWT " + widget.token
        },
        body: json.encode({"name": medname}));

    var res = json.decode(response.body);
  }

  Future<void> orderplaced(
      String username, String orderedmeds, double totalcost) async {
        //https://owaismedplus.herokuapp.com/add_order
    final String url = "https://d5467778.ngrok.io/add_order";
    var response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "JWT " + widget.token
        },
        body: json.encode(
            {"username": username, "items": orderedmeds, "cost": totalcost,"payment-type":dropdownstr}));

    var res = json.decode(response.body);
    
  }

  handletakephoto() async {
    Navigator.of(context).pop();
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this.file = file;
      presuploaded = true;
      dropdownstr = "Cash on Delivery";
    });
    Fluttertoast.showToast(
        msg: "Prescription successfully uploaded",
        
        fontSize: 15);
  }

  handlegallerychoose() async {
    Navigator.of(context).pop();
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
      presuploaded = true;
      dropdownstr = "Cash on Delivery";
    });
    Fluttertoast.showToast(
        msg: "Prescription successfully uploaded",
        );
    Fluttertoast.showToast(
        msg:
            "Your payment method is set to Cash on delivery because of prescription. Dont Change it.",
        );
  }

  selectImage(ctx) {
    return showDialog(
        context: ctx,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload Prescription"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo from camera"),
                onPressed: handletakephoto,
              ),
              SimpleDialogOption(
                child: Text("Photo from Galley"),
                onPressed: handlegallerychoose,
              ),
              SimpleDialogOption(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop())
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlepaymentsuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlepaymenterror);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlepaymentexternalwallet);
  }

  @override
  void dispose() {
   
    super.dispose();
    _razorpay.clear();
  }

  void opencheckout() {
    var options = {
      'key': 'rzp_test_bCLpdFleIzy3Tr',
      'amount': func(d) * 100,
      'name': 'medPlus',
      'Description': 'Test',
      'prefill': {'contact': '', 'email': ""},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);

    } catch (e) {

    }
  }

  void _handlepaymentsuccess(PaymentSuccessResponse r)async {
    Fluttertoast.showToast(msg: "Successlol" + r.paymentId);
    String x="";
     setState(() {
         loading = true;
       });
     print("execution started");
       for (int i = 0;
           i < widget.cartlist.length;
           i++) {
         update(cartlist[i].name);
         await Future.delayed(
                 const Duration(milliseconds: 600))
             .then((val) {});
         x = x + cartlist[i].name + "||";
       }
       orderplaced(widget.email, x, func(d));
       
        
          await createpdf(
              widget.cartlist, func(d), widget.email);
              print("kuch toh hua hai");

          setState(() {
            widget.cartlist.length = 0;
            Provider.of<cbloc>(context, listen: false)
                .counter = 0;
          });

          setState(() {
            loading = false;
          });

          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Amazing'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'Thankyou for placing the order :)'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Feedback'),
                    onPressed: () async {
                      final Email email = Email(
                        body: 'Email body',
                        subject: 'Email subject',
                        recipients: [
                          'example@example.com'
                        ],
                        cc: ['cc@example.com'],
                        bcc: ['bcc@example.com'],
                        isHTML: false,
                      );

                      await FlutterEmailSender.send(
                          email);

                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
          Navigator.pop(context);

                                
    setState(() {
      paid = true;
    });
  }

  void _handlepaymenterror(PaymentFailureResponse r) {
    Fluttertoast.showToast(
        msg: "Failurelol" + r.code.toString() + "-" + r.message);
    setState(() {
      paid = false;
    });
  }

  void _handlepaymentexternalwallet(ExternalWalletResponse r) {
    Fluttertoast.showToast(msg: "Externallol" + r.walletName);
    setState(() {
      paid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
              children:<Widget>[ 
                Background(),
                Container(
          child: loading
              ? Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("images/load.gif"),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ))
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "My Cart",
                              style: TextStyle(
                                fontSize: 0.0352 * height,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 0.47 * height,
                              width: 0.8216 * height,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.cartlist.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Card(
                                      elevation: 6,
                                      child: Padding(
                                        padding: EdgeInsets.all(0.02347 * height),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "${widget.cartlist[index].name}",
                                                  style: TextStyle(
                                                      fontSize: 0.02 * height,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                                width: 200,
                                                height: 50,
                                              ),
                                              SizedBox(
                                                width: 60,
                                              ),
                                              Text("Rs" +
                                                  "${widget.cartlist[index].cost}"),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              GestureDetector(
                                                  onTap: () async {
                                                    await cartlist
                                                        .removeAt(index);
                                                    Provider.of<cbloc>(context,
                                                            listen: false)
                                                        .decrementcounter();
                                                    setState(() {
                                                      d = 0.0;
                                                      func(d);
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 0.0234 * height,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Divider(
                              height: 2.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(

                                    color: Colors.white,
                                    child: Text(
                                      "Upload Prescription",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)),
                                    onPressed: () => widget.cartlist.length == 0
                                        ? selectImage(context)
                                        : Fluttertoast.showToast(msg: "Empty your cart before placing order with prescription.")),
                                        SizedBox(
                                          width: 5,

                                        ),
                                presuploaded
                                    ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white
                                      ),
                                      child: Icon(
                                        
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 25,
                                        ),
                                    )
                                    : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white
                                      ),
                                      child: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 25,
                                        ),
                                    ),
                                      

                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: TextField(
                                      decoration:
                                          InputDecoration(
                                            hintText: "Promo Code",
                                            
                                            ) ,
                                      onChanged: (value) {
                                        promo = value;
                                      },
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  color: Colors.white54,
                                    onPressed: () {
                                      if (widget.cartlist.length > 4) {
                                        if (promo == "first20") {
                                          setState(() {
                                            d = 0.2;
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Enter valid promo code",
                                              
                                              fontSize: 0.02 * height);
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Add atleast 5 items",
                                            
                                            fontSize: 0.02 * height);
                                      }
                                      setState(() {
                                        promo = "";
                                      });
                                    },
                                    child: Text("Submit"))
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(0.023 * height),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Total Amount",
                                    style: TextStyle(
                                      fontSize: 0.0352 * height,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Rs " + "${func(d)}",
                                    style: TextStyle(
                                      fontSize: 0.0352 * height,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Center(
                          child: DropdownButton<String>(
                            
                            value: dropdownstr,
                            onChanged: (String newval) {
                              setState(() {
                                dropdownstr = newval;
                              });
                            },
                            items: <String>["Cash on Delivery", "Online Payment"]
                                .map<DropdownMenuItem<String>>((String val) {
                              return DropdownMenuItem<String>(
                                  value: val, child: Text(val));
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 0.0352 * 2 * height,
                              right: 0.0352 * 2 * height),
                          child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              color: Colors.white,
                              onPressed: () async {
                                Directory directory =
                                    await getExternalStorageDirectory();
                                String path = directory.path;
                                if (widget.cartlist.length == 0 && file == null) {
                                  Fluttertoast.showToast(
                                      msg: "Your cart is empty",
                                      );
                                } else if (widget.cartlist.length == 0 &&
                                    file != null) {
                                  if (dropdownstr == "Cash on Delivery") {
                                    setState(() {
                                      loading = true;
                                    });
                                    String base64Image =
                                        base64Encode(file.readAsBytesSync());
                                    prescriptionsend(base64Image);
                                    setState(() {
                                      widget.cartlist.length = 0;
                                      Provider.of<cbloc>(context, listen: false)
                                          .counter = 0;
                                    });
                                    setState(() {
                                      loading = false;
                                    });
                                    await showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Amazing'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(
                                                    'Your order will be placed shortly by verifying the prescription '),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Feedback'),
                                              onPressed: () async {
                                                final Email email = Email(
                                                  body: 'Email body',
                                                  subject: 'Email subject',
                                                  recipients: [
                                                    'example@example.com'
                                                  ],
                                                  cc: ['cc@example.com'],
                                                  bcc: ['bcc@example.com'],
                                                  isHTML: false,
                                                );

                                                await FlutterEmailSender.send(
                                                    email);

                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('Close'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    Navigator.of(context).pop();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please change to Cash on delivery and try again");
                                  }
                                } else {
                                  String x = "";

                                  if (dropdownstr == "Online Payment" &&
                                      file == null &&
                                      widget.cartlist.length > 0) {
                                    opencheckout();                                  
                                  }
                                  if (dropdownstr == "Cash on Delivery" &&
                                      file == null &&
                                      widget.cartlist.length > 0) {
                                    setState(() {
                                      loading = true;
                                    });

                                    for (int i = 0;
                                        i < widget.cartlist.length;
                                        i++) {
                                      update(cartlist[i].name);
                                      await new Future.delayed(
                                              const Duration(milliseconds: 600))
                                          .then((val) {});
                                      x = x + cartlist[i].name + "||";
                                    }
                                    
                                    orderplaced(widget.email, x, func(d));
                                    
                                    await createpdf(
                                        widget.cartlist, func(d), widget.email);

                                    setState(() {
                                      widget.cartlist.length = 0;
                                      Provider.of<cbloc>(context, listen: false)
                                          .counter = 0;
                                    });

                                    setState(() {
                                      loading = false;
                                    });

                                    await showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Amazing'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(
                                                    'ThankYou for placing the order :)'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Feedback'),
                                              onPressed: () async {
                                                final Email email = Email(
                                                  body: 'Email body',
                                                  subject: 'Email subject',
                                                  recipients: [
                                                    'example@example.com'
                                                  ],
                                                  cc: ['cc@example.com'],
                                                  bcc: ['bcc@example.com'],
                                                  isHTML: false,
                                                );

                                                await FlutterEmailSender.send(
                                                    email);

                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('Close'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Place Order",
                                  style: TextStyle(
                                      fontSize: 0.0252 * height,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
        ),]
      ),
    );
  }
}

double func(double dis) {
  var a = 0.0;
  for (int i = 0; i < cartlist.length; i++) {
    a += cartlist[i].cost;
  }
  a = a - dis * a;
  return a;
}
