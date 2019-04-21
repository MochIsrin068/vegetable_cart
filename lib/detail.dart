import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './cart.dart';

class Detail extends StatelessWidget {
  final String name;
  final String url;
  final String desc;
  final String price;

  Detail({this.name, this.url, this.desc, this.price});

  createData() {
    final document = Firestore.instance.collection('sayur').document(name);

    Map<String, dynamic> data = {
      'name': name,
      'img': url,
      'desc': desc,
      'price': price
    };

    document.setData(data).whenComplete(() {
      return SnackBar(
        content: Text("$name sudah ditambahkan ke keranjang"),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      Container(
          color: Colors.red,
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "back $name",
                onPressed: () {
                  Navigator.of(context).pop();
                },
                backgroundColor: Colors.amber,
                child: Icon(Icons.arrow_back_ios),
              ),
              Text(name,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              FloatingActionButton(
                heroTag: "cart $name",
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Cart()));
                },
                backgroundColor: Colors.amber,
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Icon(Icons.shopping_basket),
                    StreamBuilder(
                        stream: Firestore().collection('sayur').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data.documents.length > 0) {
                            return Positioned(
                                left: 10.0,
                                child: CircleAvatar(
                                  radius: 9.0,
                                  backgroundColor: Colors.red,
                                  child: Text(snapshot.data.documents.length
                                      .toString()),
                                ));
                          } else {
                            return Text('');
                          }
                        })
                  ],
                ),
              ),
            ],
          )),
      Stack(
        children: <Widget>[
          Hero(
            tag: name + price,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(url), fit: BoxFit.cover)),
            ),
          )
        ],
      ),
      Container(
        padding: EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(50.0))),
          // color: Colors.transparent,
          elevation: 10.0,
          child: Container(
            width: MediaQuery.of(context).size.width - 50.0,
            height: MediaQuery.of(context).size.height / 2 - 35.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                Text(desc,
                    style: TextStyle(
                      fontSize: 16.0,
                    )),
                SizedBox(height: 20.0),
                Text("Rp. $price",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                SizedBox(height: 50.0),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      heroTag: "cartButton",
                      backgroundColor: Colors.red,
                      onPressed: () {
                        createData();
                      },
                      icon: Icon(Icons.shopping_basket),
                      label: Text("Add To Cart"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
