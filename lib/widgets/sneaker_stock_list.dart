import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SneakerStockList extends StatefulWidget {
  const SneakerStockList({Key? key}) : super(key: key);

  @override
  State<SneakerStockList> createState() => _SneakerStockListState();
}

class _SneakerStockListState extends State<SneakerStockList> {
  final _formKey = GlobalKey<FormState>();
  String sIsSold = 'No';

  final soldAtController = TextEditingController();

  final _purchasedDateController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Stock Available'),
          Column(
            children: [
              Text('List'),
            ],
          ),
          RawMaterialButton(
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
          )
        ],
      ),
    );
  }
}
