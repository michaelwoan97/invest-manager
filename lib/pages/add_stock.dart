import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/take_picture_page.dart';
import 'package:invest_manager/widgets/sneaker_stock_list.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/sneaker.dart';

class AddStock extends StatefulWidget {
  static const routeName = '/add-stock';
  late Sneaker newSneaker;

  AddStock({Key? key}) : super(key: key);

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
    widget.newSneaker = Sneaker(sID: uuid.v1(), sName: '');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Info'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.close_sharp))
        ],
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
                            width:150,
                            child: TextFormField(
                              controller: _sneakerNameController,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the stock's name";
                                }
                                return null;
                              },
                              decoration: InputDecoration(labelText: "Sneaker Name"),
                            ),
                          ),
                          SizedBox(
                            width:150,

                            child: TextFormField(
                                controller: _sneakerNotesController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                decoration: InputDecoration(labelText: "Notes")),
                          ),

                        ],
                      ),
                      Consumer<Sneaker>(
                        builder: (ctx, sneaker, _) => Column(
                          children: [
                            if(result == null)...[
                              Text('Use camera to take picture')
                            ]
                            else...[
                              Image.file(File(result[0]), height: 160, width: 180, fit: BoxFit.cover,)
                            ],
                            ElevatedButton(onPressed: () async {
                              result = await Navigator.of(context).pushNamed(TakePictureScreen.routeName);
                              sneaker.setImgUrl = result[0];
                              print('Sneaker id is ' + sneaker.getID);

                            }, child: Icon(Icons.camera))

                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SneakerStockList()
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ElevatedButton(
          onPressed: (){
            widget.newSneaker.setSneakerName = _sneakerNameController.text;
            if(_sneakerNotesController.text.isNotEmpty){
              widget.newSneaker.setNotes = _sneakerNotesController.text;
            }
            SneakerManager().addNewSneakerToList(widget.newSneaker);
            for(var e in SneakerManager().getListSneaker){
              print('Sneaker name is ' + e.getSneakerName);
            }
            Navigator.of(context).pop();
          },
          child: Text("+ Add to the list"),
        ),
      ),
    );
  }
}
