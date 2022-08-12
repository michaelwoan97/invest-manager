import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invest_manager/models/sneaker_detail.dart';
import 'package:provider/provider.dart';

import '../models/sneaker.dart';

class SneakerStockList extends StatefulWidget {
  SneakerStockList({Key? key}) : super(key: key);
  late Sneaker _newSneaker;
  late List<SneakerDetail> _sneakerAvailable;

  @override
  State<SneakerStockList> createState() => _SneakerStockListState();
}

class _SneakerStockListState extends State<SneakerStockList> {
  final _formKey = GlobalKey<FormState>();
  String sIsSold = 'No';

  // controllers
  final _purchasedFromController = TextEditingController();
  final _purchasedDateController = TextEditingController();
  final _sizeController = TextEditingController();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final soldAtController = TextEditingController();

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
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    setState((){
                                      _purchasedDateController.text = formattedDate;
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
                                controller: _qtyController,
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "QTY*",
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
                                    if(sIsSold == "Yes"){
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
                      _processNewAvailableStocks();
                      // Then, notify the list stock has changed

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
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

  Future<void> _editStockInfoDialog(SneakerDetail stock, int position) async {
    _purchasedFromController.text = stock.getSellerName;
    _purchasedDateController.text = stock.getDatePurchased;
    _sizeController.text = stock.getSneakerSize;
    _priceController.text = stock.getSneakerPrice;
    if(stock.isSneakerSold){
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
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    setState((){
                                      _purchasedDateController.text = formattedDate;
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
                                    if(sIsSold == "Yes"){
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
                        _editStockInfoDialog(stock, position);
                      // Then, notify the list stock has changed

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
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

  void _processNewAvailableStocks(){
    List<SneakerDetail> newStockAvailable = [];
    // start adding to the available stock
    SneakerDetail newSneakerStock = SneakerDetail(sSeller: _purchasedFromController.text, sDate: _purchasedDateController.text, sSize: _sizeController.text, sPrice: _priceController.text, isSold: sIsSold == "Yes" ? true : false, sPriceSold: soldAtController.text );
    newStockAvailable.add(newSneakerStock);

    //check whether the quantity is more than 1
    int quantity = int.parse(_qtyController.text);
    if( quantity > 1){
      for(int i = 1; i < quantity; i++ ){
        newStockAvailable.add(newSneakerStock);
      }
    }

    widget._sneakerAvailable = List.from(newStockAvailable);
    _purchasedFromController.text = '';
    _purchasedDateController.text = '';
    _sizeController.text = '';
    _priceController.text = '';
    sIsSold = 'No';
    soldAtController.text = '';
    widget._newSneaker.modifyAvailableStocks(newStockAvailable);
  }

  void _editSneakerStock(int position){
    SneakerDetail newSneakerStockInfo;

    // check whether it is sold or not
    if(sIsSold == "Yes"){
      newSneakerStockInfo = new SneakerDetail(sSeller: _purchasedFromController.text, sDate: _purchasedDateController.text, sSize: _sizeController.text, sPrice: _priceController.text, isSold: true, sPriceSold:  soldAtController.text);
    } else {
      newSneakerStockInfo =  new SneakerDetail(sSeller: _purchasedFromController.text, sDate: _purchasedDateController.text, sSize: _sizeController.text, sPrice: _priceController.text, isSold: false);
    }

    _purchasedFromController.text = '';
    _purchasedDateController.text = '';
    _sizeController.text = '';
    _priceController.text = '';
    sIsSold = 'No';
    soldAtController.text = '';
    widget._sneakerAvailable[position].updateSneakerStock(newSneakerStockInfo);
  }

  Widget _stockListTile(SneakerDetail stock, int position){
    return Card(
      child: InkResponse(
        onTap: () => {
          _editStockInfoDialog(stock, position)
        },
        child: ListTile(
          leading: Text(stock.getSneakerSize),
          title: Text(stock.getSellerName + " ( " + stock.getDatePurchased + ")"),
          subtitle: Text('Price: ' + stock.getSneakerPrice),
          trailing: TextButton(
            onPressed: (){},
            child: Text( stock.isSneakerSold ? "Sold" : "Active"),
            style: TextButton.styleFrom(
              primary: stock.isSneakerSold ? Colors.red : Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget._newSneaker = Provider.of<Sneaker>(context);
    widget._sneakerAvailable = widget._newSneaker.getAvailableStocks;
    print('Sneaker id is ' + widget._newSneaker.getID);
    return Container(
      child: Column(
        children: [
          Text('Stock Available'),
          Column(
            children: [
              if(widget._sneakerAvailable.isEmpty)...[
                Text('List')
              ] else...[

                SizedBox(
                  height: 230,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget._sneakerAvailable.length,
                      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                          value: widget._sneakerAvailable[index],
                          child: Consumer<SneakerDetail>(
                              builder: (context, sneakerInfo, _) => _stockListTile(widget._sneakerAvailable[index], index)))),
                )
              ],
            ],
          ),
          Consumer<Sneaker>(
            builder: (context, sneaker, _) => RawMaterialButton(
              onPressed: () {
                _showAddStockDialog();
              },
              elevation: 2.0,
              fillColor: Colors.orange,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
    );
  }
}


// not use any more because cant update the sold at text field if not using
// setState in the statefulbuilder
// Widget _dropDownTypesButton() {
//   return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: "Is Sold?"
//       ),
//       items: const [
//         DropdownMenuItem(child: Text('Yes'), value: 'Yes'),
//         DropdownMenuItem(child: Text('No'), value: 'No'),
//       ],
//       value: sIsSold,
//       onChanged: (selectedValue) {
//         if (selectedValue is String) {
//           setState(() {
//             sIsSold = selectedValue;
//           });
//         }
//       });
// }