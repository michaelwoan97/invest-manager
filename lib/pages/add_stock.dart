import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/take_picture_page.dart';
import 'package:invest_manager/widgets/sneaker_stock_list.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/sneaker.dart';

enum Scenarios { add, edit }

class AddStock extends StatefulWidget {
  static const routeName = '/add-stock';
  late Sneaker newSneaker;
  late Scenarios scenarios;

  AddStock({Scenarios? scenario, Key? key}) {
    scenarios = scenario ?? Scenarios.add;
  }

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  var result;
  var uuid = Uuid();

  final _formKey = GlobalKey<FormState>();
  final _sneakerNameController = TextEditingController();
  final _sneakerNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments == null) {
      widget.newSneaker = Sneaker(sID: uuid.v1(), sName: '');
    } else {
      final sneakerData = ModalRoute.of(context)!.settings.arguments as List;

      widget.newSneaker = sneakerData[0] as Sneaker;
      widget.scenarios = sneakerData[1] as Scenarios;
      _sneakerNameController.text = widget.newSneaker.getSneakerName;
      result = widget.newSneaker.getImgUrl;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Info'),
        actions: [IconButton(onPressed: () {
          widget.newSneaker.clearAvailableStockExisted();
          Navigator.of(context).pop();
        }, icon: Icon(Icons.close_sharp))],
      ),
      body: ChangeNotifierProvider.value(
        value: widget.newSneaker,
        builder: (context, child) => Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 150,
                            child: TextFormField(
                              controller: _sneakerNameController,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the stock's name";
                                }
                                return null;
                              },
                              decoration:
                                  InputDecoration(labelText: "Sneaker Name"),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: TextFormField(
                                controller: _sneakerNotesController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                decoration:
                                    InputDecoration(labelText: "Notes")),
                          ),
                        ],
                      ),
                      Consumer<Sneaker>(
                        builder: (ctx, sneaker, _) => Column(
                          children: [
                            if (result == null || widget.newSneaker.getImgUrl.isEmpty) ...[
                              Text('Use camera to take picture')
                            ] else ...[
                              if (result.toString().contains("http")) ...[
                                Image.network(result.toString(),
                                    height: 160, width: 180, fit: BoxFit.cover)
                              ] else ...[
                                Image.file(
                                  File(result),
                                  height: 160,
                                  width: 180,
                                  fit: BoxFit.cover,
                                )
                              ]
                            ],
                            ElevatedButton(
                                onPressed: () async {
                                  result = await Navigator.of(context)
                                      .pushNamed(TakePictureScreen.routeName);
                                  result = result[0].toString();

                                  // check scenario
                                  if(widget.scenarios == Scenarios.edit){
                                    sneaker.notifyWithoutUpdateData();
                                  } else {
                                    sneaker.updateImgURLNotify(result);
                                  }

                                  print('Sneaker id is ' + sneaker.getID);
                                },
                                child: Icon(Icons.camera))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                if(widget.scenarios == Scenarios.edit)...[
                  SneakerStockList(scenarioProcessing: Scenarios.edit)
                ] else...[
                  SneakerStockList(scenarioProcessing: Scenarios.add)
                ]

              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ElevatedButton(
          onPressed: () {
            if(widget.scenarios == Scenarios.edit){
              // update sneaker
              widget.newSneaker.updateSneaker(newSneakerName: _sneakerNameController.text, sNewNotes: _sneakerNotesController.text, sNewImgURL: result);
            } else {
              widget.newSneaker.setSneakerName = _sneakerNameController.text;
              if (_sneakerNotesController.text.isNotEmpty) {
                widget.newSneaker.setNotes = _sneakerNotesController.text;
              }
              //update new sneaker to total
              double totalNewSneakerPrice = 0;
              if(widget.newSneaker.getAvailableStocks.isNotEmpty){
                for(var e in widget.newSneaker.getAvailableStocks){
                  totalNewSneakerPrice += double.parse(e.getSneakerSoldPrice);
                }
              }
              SneakerManager().updateTotalAvaiSoldProducts(widget.newSneaker.getAvailableStocks.length, totalNewSneakerPrice);
              SneakerManager().addNewSneakerToList(widget.newSneaker);

            }

            widget.newSneaker.clearAvailableStockExisted();
            Navigator.of(context).pop();
          },
          child: widget.scenarios == Scenarios.add
              ? Text("+ Add to the list")
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.edit), Text("Edit Sneaker Info!!")],
                ),
        ),
      ),
    );
  }
}
