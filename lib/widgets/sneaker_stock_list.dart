import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invest_manager/models/sneaker_detail.dart';
import 'package:invest_manager/pages/add_stock.dart';
import 'package:invest_manager/styles/responsive/font_sizes.dart';
import 'package:invest_manager/styles/responsive_layout.dart';
import 'package:invest_manager/styles/theme_styles.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/sneaker.dart';
import '../styles/responsive/breakpoints.dart';

/*
* class: SneakerStockList
* purpose: this class is used for creating SneakerStockList widget
* */
class SneakerStockList extends StatefulWidget {
  late Sneaker _newSneaker;
  late List<SneakerDetail> _sneakerAvailable;
  late Scenarios scenario;


  SneakerStockList({required Scenarios scenarioProcessing, Key? key}) {
    scenario = scenarioProcessing;
  }

  @override
  State<SneakerStockList> createState() => _SneakerStockListState();
}

class _SneakerStockListState extends State<SneakerStockList> {
  late GlobalKey<FormState> _formKey;
  late bool isCopied = false;
  String sIsSold = 'No';

  // controllers
  final _purchasedFromController = TextEditingController();
  final _purchasedDateController = TextEditingController();
  final _sizeController = TextEditingController();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final soldAtController = TextEditingController();

  // purpose: used for creating add stock dialog
  Future<void> _showAddStockDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adding Stocks'),
              content: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _purchasedFromController,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the seller';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Purchase From*",
                          ),
                        ),
                        TextFormField(
                          controller: _purchasedDateController,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the date you purchased';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Purchase Date*",
                              suffix: IconButton(
                                icon: Icon(Icons.date_range),
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    setState(() {
                                      _purchasedDateController.text =
                                          formattedDate;
                                    });
                                  }
                                },
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 50,
                              child: TextFormField(
                                controller: _sizeController,
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Size*",
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   width: 50,
                            //   child: TextFormField(
                            //     controller: _qtyController,
                            //     // The validator receives the text that the user has entered.
                            //     validator: (value) {
                            //       if (value == null || value.isEmpty) {
                            //         return '';
                            //       }
                            //       return null;
                            //     },
                            //     decoration: InputDecoration(
                            //       labelText: "QTY*",
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              width: 50,
                              child: TextFormField(
                                controller: _priceController,
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Price*",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 50,
                              child: DropdownButtonFormField<String>(
                                  decoration:
                                      InputDecoration(labelText: "Is Sold?"),
                                  items: const [
                                    DropdownMenuItem(
                                        child: Text('Yes'), value: 'Yes'),
                                    DropdownMenuItem(
                                        child: Text('No'), value: 'No'),
                                  ],
                                  value: sIsSold,
                                  onChanged: (selectedValue) {
                                    if (selectedValue is String) {
                                      setState(() {
                                        sIsSold = selectedValue;
                                        if (sIsSold == "No") {
                                          soldAtController.text = "";
                                        }
                                      });
                                    }
                                  }),
                            ),
                            SizedBox(
                              width: 65,
                              child: TextFormField(
                                enabled: sIsSold == "Yes" ? true : false,
                                controller: soldAtController,

                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    // check whether it is sold or not
                                    if (sIsSold == "Yes") {
                                      return '';
                                    }
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Sold At*",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            )
                          ],
                        )
                      ],
                    )),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    clearForm();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      // call function to process data
                      _processAvailableStocks();
                      // Then, notify the list stock has changed
                      // _formKey = GlobalKey<FormState>();

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to the list', style: AppTheme.kFontSizeMobileBodyText,)),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // purpose: used for creating edit stock dialog
  Future<void> _editStockInfoDialog(SneakerDetail stock, int position) async {
    _purchasedFromController.text = stock.getSellerName;
    _purchasedDateController.text = stock.getDatePurchased;
    _sizeController.text = stock.getSneakerSize;
    _priceController.text = stock.getSneakerPrice;
    if (stock.isSneakerSold) {
      sIsSold = 'Yes';
      soldAtController.text = stock.getSneakerSoldPrice;
    } else {
      sIsSold = 'No';
      soldAtController.text = '';
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adding Stocks'),
              content: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _purchasedFromController,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the seller';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Purchase From*",
                          ),
                        ),
                        TextFormField(
                          controller: _purchasedDateController,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the date you purchased';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Purchase Date*",
                              suffix: IconButton(
                                icon: Icon(Icons.date_range),
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    setState(() {
                                      _purchasedDateController.text =
                                          formattedDate;
                                    });
                                  }
                                },
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 50,
                              child: TextFormField(
                                controller: _sizeController,
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Size*",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextFormField(
                                controller: _priceController,
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Price*",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 50,
                              child: DropdownButtonFormField<String>(
                                  decoration:
                                      InputDecoration(labelText: "Is Sold?"),
                                  items: const [
                                    DropdownMenuItem(
                                        child: Text('Yes'), value: 'Yes'),
                                    DropdownMenuItem(
                                        child: Text('No'), value: 'No'),
                                  ],
                                  value: stock.isSneakerSold ? 'Yes' : 'No',
                                  onChanged: (selectedValue) {
                                    if (selectedValue is String) {
                                      setState(() {
                                        sIsSold = selectedValue;
                                        if (sIsSold == "No") {
                                          soldAtController.text = "";
                                        }
                                      });
                                    }
                                  }),
                            ),
                            SizedBox(
                              width: 65,
                              child: TextFormField(
                                enabled: sIsSold == "Yes" ? true : false,
                                controller: soldAtController,

                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    // check whether it is sold or not
                                    if (sIsSold == "Yes") {
                                      return '';
                                    }
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Sold At*",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            )
                          ],
                        )
                      ],
                    )),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    clearForm();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Edit'),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      // call function to process data
                      _editSneakerStock(stock, position);
                      // Then, notify the list stock has changed

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Updated Data')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // purpose: used for editing/updating new available stocks
  void _editSneakerStock(SneakerDetail stock, int position) {
    SneakerDetail newSneakerStockInfo;

    // check whether it is sold or not
    if (sIsSold == "Yes") {
      newSneakerStockInfo = new SneakerDetail(
          sSeller: _purchasedFromController.text,
          sDate: _purchasedDateController.text,
          sSize: _sizeController.text,
          sPrice: _priceController.text,
          isSold: true,
          sPriceSold: soldAtController.text);
    } else {
      newSneakerStockInfo = new SneakerDetail(
          sSeller: _purchasedFromController.text,
          sDate: _purchasedDateController.text,
          sSize: _sizeController.text,
          sPrice: _priceController.text,
          isSold: false);
    }

    clearForm();

    // check whether the user are adding or edditng the stock avaiable
    if (widget.scenario == Scenarios.edit) {
      widget._newSneaker.getCopiedOfArrAvailable[position]
          .updateSneakerStock(newSneakerStockInfo);
    } else {
      widget._newSneaker.addToCopiedAvailableStock(newSneakerStockInfo);
    }
  }

  // purpose: used for processing new available stocks
  void _processAvailableStocks() {
    List<SneakerDetail> newStockAvailable = [];
    // start adding to the available stock
    SneakerDetail newSneakerStock = SneakerDetail(
        sSeller: _purchasedFromController.text,
        sDate: _purchasedDateController.text,
        sSize: _sizeController.text,
        sPrice: _priceController.text,
        isSold: sIsSold == "Yes" ? true : false,
        sPriceSold: soldAtController.text);
    newStockAvailable.add(newSneakerStock);

    // not working with the logic update each element but might take a look in a future
    //check whether the quantity is more than 1
    // int quantity = int.parse(_qtyController.text);
    // if( quantity > 1){
    //   for(int i = 1; i < quantity; i++ ){
    //     newStockAvailable.add(newSneakerStock);
    //   }
    // }

    clearForm();

    // check whether the user are adding or edditng the stock avaiable
    if (widget.scenario == Scenarios.edit) {
      widget._newSneaker.addToCopiedAvailableStock(newSneakerStock);
    } else {
      widget._newSneaker.modifyAvailableStocks(newStockAvailable);
    }
  }

  // purpose: used for clearing data of a form
  void clearForm() {
    _purchasedFromController.text = '';
    _purchasedDateController.text = '';
    _sizeController.text = '';
    _priceController.text = '';
    sIsSold = 'No';
    soldAtController.text = '';
  }



  /*
  * purpose: different layout when the app reach mobile breakpoints
  * */
  Widget _stockListTileMobile(SneakerDetail stock, int position) {
    return Card(
      elevation: AppTheme.cardElevation(),
      child: InkResponse(
        onTap: () => {_editStockInfoDialog(stock, position)},
        child: ListTile(
          leading: Text(
            stock.getSneakerSize,
            style: TextStyle(fontSize: kMobileBodyText),
          ),
          title: Text(
            stock.getSellerName + " ( " + stock.getDatePurchased + ")",
            style: TextStyle(fontSize: kMobileBodyText),
          ),
          subtitle: Text(
            'Price: ' + stock.getSneakerPrice,
            style: TextStyle(fontSize: kMobileBodyText),
          ),
          trailing: TextButton(
            onPressed: () {},
            child: Text(
              stock.isSneakerSold ? "Sold" : "Active",
              style: TextStyle(fontSize: kMobileBodyText),
            ),
            style: TextButton.styleFrom(
              primary: stock.isSneakerSold ? Colors.red : Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  /*
  * purpose: different layout when the app reach desktop/tablet breakpoints
  * */
  Widget _stockListTileDesktop(SneakerDetail stock, int position) {
    return Card(
      elevation: AppTheme.cardElevation(),
      child: InkResponse(
        onTap: () => {_editStockInfoDialog(stock, position)},
        child: ListTile(
          leading: Text(
            stock.getSneakerSize,
            style: TextStyle(fontSize: kDesktopBodyText),
          ),
          title: Text(
            stock.getSellerName + " ( " + stock.getDatePurchased + ")",
            style: TextStyle(fontSize: kDesktopBodyText),
          ),
          subtitle: Text(
            'Price: ' + stock.getSneakerPrice,
            style: TextStyle(fontSize: kDesktopBodyText),
          ),
          trailing: TextButton(
            onPressed: () {},
            child: Text(
              stock.isSneakerSold ? "Sold" : "Active",
              style: TextStyle(fontSize: kDesktopBodyText),
            ),
            style: TextButton.styleFrom(
              primary: stock.isSneakerSold ? Colors.red : Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    var uuid = Uuid();
    widget._newSneaker = Provider.of<Sneaker>(context);

    // when edit
    // check whether is adding stock or editting
    // if editting tem
    if (widget.scenario == Scenarios.edit) {
      // check whether it has been copy the current list of stock list info
      if (isCopied == false) {
        widget._newSneaker.createCoptyOfStockList();
        isCopied = true;
      }
      widget._sneakerAvailable = widget._newSneaker.getCopiedOfArrAvailable;
    } else {
      widget._sneakerAvailable = widget._newSneaker.getAvailableStocks;
    }

    return ResponsiveLayout(
      mobileBody: _sneakerStockListMobile(),
      tabletVersion: _sneakerStockListDesktop(),
      desktopVersion: _sneakerStockListDesktop(),
    );
  }

  /*
  * purpose: different layout when the app reach mobile breakpoints
  * */
  Widget _sneakerStockListMobile() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      child: Column(
        children: [
          Container(
              width: double.infinity,
              child: AutoSizeText('Stock Available',
                  style: AppTheme.displayInvenTitle(
                      context, kMobileSubHeadings))),
          if (widget._sneakerAvailable.isEmpty) ...[
            const Center(
              child: AutoSizeText(
                'Empty! Please add something to the list!!!',
                style: TextStyle(fontSize: kMobileBodyText),
              ),
            )
          ] else ...[
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget._sneakerAvailable.length,
                  itemBuilder: (ctx, index) =>
                      ChangeNotifierProvider.value(
                          value: widget._sneakerAvailable[index],
                          child: Consumer<SneakerDetail>(
                              builder: (context, sneakerInfo, _) =>
                                  Dismissible(
                                      key: Key(Uuid().v1()),
                                      background:
                                          Container(color: Colors.red),
                                      direction:
                                          DismissDirection.endToStart,
                                      onDismissed: (direction) {
                                        widget._newSneaker
                                            .deleteStockCopiedList(index);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Deleted stock!!!',
                                                  style: TextStyle(
                                                      fontSize:
                                                          kMobileBodyText))),
                                        );
                                        // Scaffold
                                        //     .of(context)
                                        //     .showSnackBar(SnackBar(content: Text("$item dismissed")));
                                      },
                                      child: Container(
                                        margin: AppTheme
                                            .spaceBetweenInEList(),
                                        child: ResponsiveLayout(
                                          mobileBody: _stockListTileMobile(
                                              widget._sneakerAvailable[
                                              index],
                                              index),
                                          tabletVersion:
                                          _stockListTileDesktop(
                                              widget._sneakerAvailable[
                                              index],
                                              index),
                                          desktopVersion:
                                          _stockListTileDesktop(
                                              widget._sneakerAvailable[
                                              index],
                                              index),
                                        ),
                                      ))))),
            )
          ],
          Consumer<Sneaker>(
            builder: (context, sneaker, _) => Container(
              child: RawMaterialButton(
                onPressed: () {
                  _showAddStockDialog();
                },
                elevation: 2.0,
                fillColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                // padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }

  /*
  * purpose: different layout when the app reach desktop/tablet breakpoints
  * */
  Widget _sneakerStockListDesktop() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      child: Column(
        children: [
          Container(
              width: double.infinity,
              child: AutoSizeText('Stock Available',
                  style: AppTheme.displayInvenTitle(
                      context, kDesktopSubHeadings))),
          if (widget._sneakerAvailable.isEmpty) ...[
            const Center(
              child: AutoSizeText(
                'Empty! Please add something to the list!!!',
                style: TextStyle(fontSize: kDesktopBodyText),
              ),
            )
          ] else ...[
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget._sneakerAvailable.length,
                  itemBuilder: (ctx, index) =>
                      ChangeNotifierProvider.value(
                          value: widget._sneakerAvailable[index],
                          child: Consumer<SneakerDetail>(
                              builder: (context, sneakerInfo, _) =>
                                  Dismissible(
                                      key: Key(Uuid().v1()),
                                      background:
                                      Container(color: Colors.red),
                                      direction:
                                      DismissDirection.endToStart,
                                      onDismissed: (direction) {
                                        widget._newSneaker
                                            .deleteStockCopiedList(index);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Deleted stock!!!',
                                                  style: TextStyle(
                                                      fontSize:
                                                      kDesktopBodyText))),
                                        );
                                        // Scaffold
                                        //     .of(context)
                                        //     .showSnackBar(SnackBar(content: Text("$item dismissed")));
                                      },
                                      child: Container(
                                        margin: AppTheme
                                            .spaceBetweenInEList(),
                                        child: ResponsiveLayout(
                                          mobileBody: _stockListTileMobile(
                                              widget._sneakerAvailable[
                                              index],
                                              index),
                                          tabletVersion:
                                          _stockListTileDesktop(
                                              widget._sneakerAvailable[
                                              index],
                                              index),
                                          desktopVersion:
                                          _stockListTileDesktop(
                                              widget._sneakerAvailable[
                                              index],
                                              index),
                                        ),
                                      ))))),
            )
          ],
          Consumer<Sneaker>(
            builder: (context, sneaker, _) => Container(
              child: RawMaterialButton(
                onPressed: () {
                  _showAddStockDialog();
                },
                elevation: 2.0,
                fillColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                // padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }
}


