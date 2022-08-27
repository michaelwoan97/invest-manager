import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/add_stock.dart';
import 'package:provider/provider.dart';

import '../models/sneaker.dart';

class StockList extends StatelessWidget {
  late List<Sneaker> arrSneakers;

  StockList({List<Sneaker>? sneakers}) {
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
    final sneakersData = Provider.of<SneakerManager>(context);
    arrSneakers = sneakersData.getListSneaker;

    return ChangeNotifierProvider.value(
      value: SneakerManager(),
      child: Column(
        children: [
          Text("Inventory"),
          if (arrSneakers.isNotEmpty) ...[
            Consumer<SneakerManager>(
              builder: (ctx, sneakerManager, _) => Container(
                height: 500,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: arrSneakers.length,
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider.value(
                          value: arrSneakers[index],
                          child: Card(
                            child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      AddStock.routeName,
                                      arguments: [arrSneakers[index], Scenarios.edit]);
                                },
                                child: Consumer<Sneaker>(
                                  builder: (ctx, sneaker, _) => ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: arrSneakers[index]
                                          .getImgUrl
                                          .contains("http")
                                          ? NetworkImage(
                                          arrSneakers[index].getImgUrl)
                                          : FileImage(File(
                                          arrSneakers[index].getImgUrl))
                                      as ImageProvider,
                                    ),
                                    title:
                                        Text(arrSneakers[index].getSneakerName),
                                    subtitle: Text('QTY: ' +
                                        arrSneakers[index]
                                            .getAvailableStocks
                                            .length
                                            .toString()),
                                    trailing: Icon(Icons.edit),
                                  ),
                                )),
                          ),
                        )),
              ),
            )
          ]
        ],
      ),
    );
  }
}
