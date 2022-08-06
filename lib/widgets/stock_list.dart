import 'package:flutter/material.dart';

import '../models/sneaker.dart';

class StockList extends StatelessWidget {
  late List<Sneaker> arrSneakers;

  StockList(List<Sneaker>? sneakers) {
    if (sneakers != null) {
      arrSneakers = sneakers.isNotEmpty ? sneakers : [];
    } else {
      arrSneakers = [];
    }
  }

  List<Widget> _displayStockList() {
    List<Widget> sneakerNames = [];
    if (arrSneakers.isNotEmpty) {
      for (var e in arrSneakers) {
        sneakerNames.add(Text(e.getSneakerName));
      }
    } else {
      sneakerNames.add(Text("List is empty!!!!!!!!!"));
    }

    return sneakerNames;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Inventory"),
          if (arrSneakers.isNotEmpty) ...[
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: arrSneakers.length,
                itemBuilder: (context, index) {
                  Sneaker sneaker = arrSneakers[index];
                  return InkResponse(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(sneaker.getImgUrl),
                        ),
                        title: Text(sneaker.getSneakerName),
                        subtitle: Text(
                            'QTY: ' +
                                sneaker.getAvailableStocks.length.toString()),
                        trailing: Icon(Icons.edit),
                      ));
                })
          ]
        ],
      ),
    );
  }
}
