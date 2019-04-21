import 'package:flutter/material.dart';
import 'package:vegetable_cart/cart.dart';
import './product.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<String> img = [
    "assets/slider4.jpg",
    "assets/Vegetable-Banner.jpg",
    "assets/furisuka-sayuran.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
              color: Colors.red,
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {},
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.menu),
                  ),
                  Text("Vegetable Cart",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Cart()));
                    },
                    backgroundColor: Colors.amber,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Icon(Icons.shopping_basket),
                        StreamBuilder(
                            stream: Firestore.instance
                                .collection('sayur')
                                .snapshots(),
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
            alignment: Alignment.center,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: 70.0,
                color: Colors.red,
              ),
              Positioned(
                top: 20.0,
                child: Container(
                  height: 100.0,
                  width: MediaQuery.of(context).size.width / 2 + 100,
                  color: Colors.amber,
                  child: Swiper(
                    itemCount: img.length,
                    autoplay: true,
                    pagination: SwiperPagination(),
                    itemBuilder: (BuildContext context, i) {
                      return Image.asset(img[i], fit: BoxFit.cover);
                    },
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 50.0),
          Container(
            padding: EdgeInsets.all(20.0),
            child: ProductList(),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Popular"),
          ),
          Popular(),
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Favorite"),
          ),
          FavoriteList()
        ],
      ),
      bottomNavigationBar: Material(
        child: TabBar(
          indicatorColor: Colors.transparent,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.grey,
          controller: controller,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.favorite)),
            Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}
