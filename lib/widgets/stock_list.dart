import 'package:flutter/material.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
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
              builder: (ctx, sneakerManager, _) => ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: arrSneakers.length,
                  itemBuilder: (context, index) => ChangeNotifierProvider.value(
                    value: arrSneakers[index],
                    child: InkResponse(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(arrSneakers[index].getImgUrl),
                          ),
                          title: Text(arrSneakers[index].getSneakerName),
                          subtitle: Text(
                              'QTY: ' +
                                  arrSneakers[index].getAvailableStocks.length.toString()),
                          trailing: Icon(Icons.edit),
                        )),
                  )
              ),
            )
          ]
        ],
      ),
    );
  }
}
