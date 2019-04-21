import 'package:flutter/material.dart';
import './detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductList extends StatelessWidget {
  var data = [
    {
      "name": "Jagung",
      "url":
          "https://doktersehat.com/wp-content/uploads/2018/05/manfaat-jagung.jpg",
      "desc": "Jagung segar yang langsung di panen dari kebun",
      "price": "10.000"
    },
    {
      "name": "Tomat",
      "url":
          "https://res.cloudinary.com/dk0z4ums3/image/upload/v1534576505/attached_image/9-manfaat-tomat-buah-yang-disangka-sayur-alodokter.jpg",
      "desc": "Tomat segar yang langsung dipetik dari kebun",
      "price": "12.000"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 10.0 / 7.0),
      itemCount: data.length,
      itemBuilder: (BuildContext context, i) {
        return ProductCard(
          name: data[i]["name"],
          url: data[i]["url"],
          desc: data[i]["desc"],
          price: data[i]["price"],
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String url;
  final String desc;
  final String price;

  ProductCard({this.name, this.url, this.desc, this.price});

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
    return Card(
      child: Container(
        child: GridTile(
            header: Center(
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(name),
              ),
            ),
            footer: Container(
              color: Colors.white54,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: name,
                    child: Icon(Icons.more),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Detail(
                                name: name,
                                url: url,
                                desc: desc,
                                price: price,
                              )));
                    },
                    backgroundColor: Colors.red,
                  ),
                  FloatingActionButton.extended(
                    heroTag: price,
                    icon: Icon(Icons.shopping_basket),
                    label: Text("Cart"),
                    onPressed: () {
                      createData();
                    },
                    backgroundColor: Colors.red,
                  )
                ],
              ),
            ),
            child: Hero(
                tag: name + price,
                child: Image.network(url, fit: BoxFit.cover))),
      ),
    );
  }
}

class FavoriteList extends StatelessWidget {
  var data = [
    {
      "name": "Brokoli",
      "url":
          "https://sayurbuah.disukabumi.com/wp-content/uploads/2018/04/brokoli.jpg",
      "desc": "Ok ini brokoli",
      "price": "112.000"
    },
    {
      "name": "Wortel",
      "url":
          "https://res.cloudinary.com/dk0z4ums3/image/upload/v1522914788/attached_image/manfaat-wortel-bagi-kesehatan-alodokter.jpg",
      "desc": "Ok ini wortel",
      "price": "120.000"
    },
    {
      "name": "Cabai",
      "url":
          "https://hellosehat.com/wp-content/uploads/2016/10/Manfaat-Cabai.jpg",
      "desc": "Ok ini Cabai",
      "price": "142.000"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
        height: 230.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          itemBuilder: (context, i) {
            return Favorite(
              name: data[i]['name'],
              url: data[i]['url'],
              desc: data[i]['desc'],
              price: data[i]['price'],
            );
          },
        ));
  }
}

class Favorite extends StatelessWidget {
  final String name;
  final String url;
  final String desc;
  final String price;

  Favorite({this.name, this.url, this.desc, this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 10.0),
        height: 220.0,
        width: 220.0,
        child: InkWell(
          highlightColor: Colors.red,
          splashColor: Colors.amber,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Detail(
                      name: name,
                      url: url,
                      desc: desc,
                      price: price,
                    )));
          },
          child: GridTile(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50.0),
                      topLeft: Radius.circular(50.0)),
                  image: DecorationImage(
                      image: NetworkImage(url), fit: BoxFit.cover)),
            ),
            footer: Container(
              color: Colors.white54,
              height: 90.0,
              child: ListTile(
                leading: Text("$name"),
                title: Text("$price"),
              ),
            ),
          ),
        ));
  }
}

class Popular extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      height: 200.0,
      child: GridTile(
          footer: Container(
            color: Colors.white54,
            height: 70.0,
            child: Center(
              child: Text("Good Vegetable"),
            ),
          ),
          child: InkWell(
            highlightColor: Colors.red,
            splashColor: Colors.amber,
            child:
                Image.asset("assets/Vegetable-Banner.jpg", fit: BoxFit.cover),
          )),
    );
  }
}
