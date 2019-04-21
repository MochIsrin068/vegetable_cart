import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart extends StatelessWidget {
  deleteData(String name) {
    final document = Firestore.instance.collection('sayur').document(name);

    document.delete().whenComplete(() {
      print("$name Deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        backgroundColor: Colors.red,
        elevation: 0.5,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: Firestore.instance.collection('sayur').snapshots(),
          builder: (context, snap) {
            if (snap.hasData) {
              return Stack(
                children: <Widget>[
                  ListView.builder(
                    itemCount: snap.data.documents.length,
                    itemBuilder: (c, i) {
                      return Card(
                          child: Container(
                        height: 120.0,
                        child: ListTile(
                            title: Text(snap.data.documents[i]['name']),
                            subtitle:
                                Text("Rp. ${snap.data.documents[i]['price']}"),
                            trailing: FloatingActionButton.extended(
                              icon: Icon(Icons.remove_shopping_cart),
                              backgroundColor: Colors.red,
                              label: Text("Remove"),
                              onPressed: () {
                                deleteData(snap.data.documents[i]['name']);
                              },
                            ),
                            leading: Container(
                              height: 150.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          snap.data.documents[i]['img']))),
                            )),
                      ));
                    },
                  ),
                ],
              );
            } else {
              return Center(child: Text("Data Tidak Ada"));
            }
          },
        ),
      ),
    );
  }
}
