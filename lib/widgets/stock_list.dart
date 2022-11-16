import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:invest_manager/controllers/mangement_API.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/add_stock.dart';
import 'package:invest_manager/styles/responsive/font_sizes.dart';
import 'package:invest_manager/styles/responsive_layout.dart';
import 'package:invest_manager/styles/theme_styles.dart';
import 'package:invest_manager/widgets/custom_circle_avatar.dart';
import 'package:invest_manager/widgets/transition_routes.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/sneaker.dart';

/*
* class: StockList
* purpose: this class is used for creating StockList widget
* */
class StockList extends StatefulWidget {
  late List<Sneaker> arrSneakers;

  StockList({List<Sneaker>? sneakers}) {
    if (sneakers != null) {
      arrSneakers = sneakers.isNotEmpty ? sneakers : [];
    } else {
      arrSneakers = [];
    }
  }

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sneakersData = Provider.of<SneakerManager>(context);
    widget.arrSneakers = sneakersData.getListSneaker;

    return ChangeNotifierProvider.value(
      value: SneakerManager(),
      child: ResponsiveLayout(
        mobileBody: _stockListMobile(context),
        tabletVersion: _stockListTablet(context),
        desktopVersion: _stockListTablet(context),
      ),
    );
  }

  /*
  * purpose: different layout when the app reach mobile breakpoints
  * */
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
          if (widget.arrSneakers.isNotEmpty) ...[
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
                        itemCount: widget.arrSneakers.length,
                        itemBuilder: (context, index) => Container(
                              margin: AppTheme.spaceBetweenInEList(),
                              child: ChangeNotifierProvider.value(
                                value: widget.arrSneakers[index],
                                child: Dismissible(
                                  key: Key(Uuid().v1()),
                                  background: Container(color: Colors.red),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    ManagementAPI().removeSneaker(
                                        SneakerManager().accessToken,
                                        SneakerManager().userID,
                                        widget.arrSneakers[index].getID);
                                    SneakerManager().deleteSneaker(
                                        widget.arrSneakers[index].getID);

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
                                                  widget.arrSneakers[index],
                                                  Scenarios.edit
                                                ]),
                                          );
                                        },
                                        child: Consumer<Sneaker>(
                                          builder: (ctx, sneaker, _) =>
                                              ListTile(
                                            leading: CustomCircleAvatar(
                                              imgUrl: widget
                                                  .arrSneakers[index].getImgUrl,
                                              placeholderImg:
                                                  "assets/images/default_img.png",
                                            ),
                                            title: Text(
                                              widget.arrSneakers[index]
                                                  .getSneakerName,
                                              style: TextStyle(
                                                  fontSize: kMobileBodyText),
                                            ),
                                            subtitle: Text('QTY: ' +
                                                widget.arrSneakers[index]
                                                    .getAvailableStocks.length
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

  /*
  * purpose: different layout when the app reach desktop/tablet breakpoints
  * */
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
                  style: AppTheme.displayInvenTitle(
                      context, kDesktopSubHeadings))),
          if (widget.arrSneakers.isNotEmpty) ...[
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
                        itemCount: widget.arrSneakers.length,
                        itemBuilder: (context, index) => Container(
                              margin: AppTheme.spaceBetweenInEList(),
                              child: ChangeNotifierProvider.value(
                                value: widget.arrSneakers[index],
                                child: Dismissible(
                                  key: Key(Uuid().v1()),
                                  background: Container(color: Colors.red),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    ManagementAPI().removeSneaker(
                                        SneakerManager().accessToken,
                                        SneakerManager().userID,
                                        widget.arrSneakers[index].getID);
                                    SneakerManager().deleteSneaker(
                                        widget.arrSneakers[index].getID);


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
                                                  widget.arrSneakers[index],
                                                  Scenarios.edit
                                                ]),
                                          );
                                        },
                                        child: Consumer<Sneaker>(
                                          builder: (ctx, sneaker, _) =>
                                              ListTile(
                                            leading: CustomCircleAvatar(
                                              imgUrl: widget
                                                  .arrSneakers[index].getImgUrl,
                                              placeholderImg:
                                                  "assets/images/default_img.png",
                                            ),
                                            title: Text(
                                              widget.arrSneakers[index]
                                                  .getSneakerName,
                                              style: TextStyle(
                                                  fontSize: kDesktopBodyText),
                                            ),
                                            subtitle: Text('QTY: ' +
                                                widget.arrSneakers[index]
                                                    .getAvailableStocks.length
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
