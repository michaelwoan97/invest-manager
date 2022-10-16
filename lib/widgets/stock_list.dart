import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:invest_manager/controllers/mangement_API.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/add_stock.dart';
import 'package:invest_manager/styles/responsive/font_sizes.dart';
import 'package:invest_manager/styles/responsive_layout.dart';
import 'package:invest_manager/styles/theme_styles.dart';
import 'package:invest_manager/widgets/transition_routes.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
      child: ResponsiveLayout(
        mobileBody: _stockListMobile(context),
        tabletVersion: _stockListTablet(context),
        desktopVersion: _stockListTablet(context),
      ),
    );
  }

  Widget _stockListMobile(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Expanded(
              flex: 1,
              child: AutoSizeText("Inventory",
                  style:
                      AppTheme.displayInvenTitle(context, kMobileSubHeadings))),
          if (arrSneakers.isNotEmpty) ...[
            Consumer<SneakerManager>(
              builder: (ctx, sneakerManager, _) => Expanded(
                flex: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Container(
                    margin: AppTheme.spaceBetweenInListTop(),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: arrSneakers.length,
                        itemBuilder: (context, index) => Container(
                              margin: AppTheme.spaceBetweenInEList(),
                              child: ChangeNotifierProvider.value(
                                value: arrSneakers[index],
                                child: Dismissible(
                                  key: Key(Uuid().v1()),
                                  background: Container(color: Colors.red),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    ManagementAPI().removeSneaker(
                                        SneakerManager().accessToken,
                                        SneakerManager().userID,
                                        arrSneakers[index].getID);
                                    SneakerManager().deleteSneaker(
                                        arrSneakers[index].getID);

                                    // Scaffold
                                    //     .of(context)
                                    //     .showSnackBar(SnackBar(content: Text("$item dismissed")));
                                  },
                                  child: Card(
                                    elevation: AppTheme.cardElevation(),
                                    child: InkResponse(
                                        onTap: () {
                                          // Navigator.of(context).pushNamed(
                                          //     AddStock.routeName,
                                          //     arguments: [
                                          //       arrSneakers[index],
                                          //       Scenarios.edit
                                          //     ]);
                                          Navigator.push(
                                            context,
                                            TransitionRoutes(
                                                page: AddStock(),
                                                routeName: AddStock.routeName,
                                                arguments: [
                                                  arrSneakers[index],
                                                  Scenarios.edit
                                                ]),
                                          );
                                        },
                                        child: Consumer<Sneaker>(
                                          builder: (ctx, sneaker, _) =>
                                              ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  arrSneakers[index]
                                                          .getImgUrl
                                                          .contains("http")
                                                      ? NetworkImage(
                                                          arrSneakers[index]
                                                              .getImgUrl)
                                                      : FileImage(File(
                                                              arrSneakers[index]
                                                                  .getImgUrl))
                                                          as ImageProvider,
                                            ),
                                            title: Text(
                                              arrSneakers[index].getSneakerName,
                                              style: TextStyle(
                                                  fontSize: kMobileBodyText),
                                            ),
                                            subtitle: Text('QTY: ' +
                                                arrSneakers[index]
                                                    .getAvailableStocks
                                                    .length
                                                    .toString()),
                                            trailing: Icon(Icons.edit),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _stockListTablet(BuildContext context) {
    return Container(
      margin: AppTheme.spaceBetweenSectionTop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Expanded(
              flex: 1,
              child: AutoSizeText("Inventory",
                  style:
                  AppTheme.displayInvenTitle(context, kDesktopSubHeadings))),
          if (arrSneakers.isNotEmpty) ...[
            Consumer<SneakerManager>(
              builder: (ctx, sneakerManager, _) => Expanded(
                flex: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Container(
                    margin: AppTheme.spaceBetweenInListTop(),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: arrSneakers.length,
                        itemBuilder: (context, index) => Container(
                              margin: AppTheme.spaceBetweenInEList(),
                              child: ChangeNotifierProvider.value(
                                value: arrSneakers[index],
                                child: Dismissible(
                                  key: Key(Uuid().v1()),
                                  background: Container(color: Colors.red),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    ManagementAPI().removeSneaker(
                                        SneakerManager().accessToken,
                                        SneakerManager().userID,
                                        arrSneakers[index].getID);
                                    SneakerManager()
                                        .deleteSneaker(arrSneakers[index].getID);

                                    // Scaffold
                                    //     .of(context)
                                    //     .showSnackBar(SnackBar(content: Text("$item dismissed")));
                                  },
                                  child: Card(
                                    elevation: AppTheme.cardElevation(),
                                    child: InkResponse(
                                        onTap: () {
                                          // Navigator.of(context).pushNamed(
                                          //     AddStock.routeName,
                                          //     arguments: [
                                          //       arrSneakers[index],
                                          //       Scenarios.edit
                                          //     ]);
                                          Navigator.push(
                                            context,
                                            TransitionRoutes(
                                                page: AddStock(),
                                                routeName: AddStock.routeName,
                                                arguments: [
                                                  arrSneakers[index],
                                                  Scenarios.edit
                                                ]),
                                          );
                                        },
                                        child: Consumer<Sneaker>(
                                          builder: (ctx, sneaker, _) => ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: arrSneakers[index]
                                                      .getImgUrl
                                                      .contains("http")
                                                  ? NetworkImage(
                                                      arrSneakers[index]
                                                          .getImgUrl)
                                                  : FileImage(File(
                                                          arrSneakers[index]
                                                              .getImgUrl))
                                                      as ImageProvider,
                                            ),
                                            title: Text(
                                              arrSneakers[index].getSneakerName,
                                              style: TextStyle(
                                                  fontSize: kDesktopBodyText),
                                            ),
                                            subtitle: Text('QTY: ' +
                                                arrSneakers[index]
                                                    .getAvailableStocks
                                                    .length
                                                    .toString()),
                                            trailing: Icon(Icons.edit),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
