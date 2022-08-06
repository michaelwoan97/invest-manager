import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invest_manager/pages/take_picture_page.dart';

class AddStock extends StatefulWidget {
  static const routeName = '/add-stock';

  AddStock({Key? key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  var result;

  final _formKey = GlobalKey<FormState>();

  //var result = Navigator.of(context).pushNamed(TakePictureScreen.routeName);
  Future<void> _takePictureForStock (BuildContext context) async {
    result = await Navigator.of(context).pushNamed(TakePictureScreen.routeName);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Info'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
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
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(labelText: "Notes")),
                      ),

                    ],
                  ),
                  Column(

                    children: [
                      if(result == null)...[
                        Text('Use camera to take picture')
                      ]
                      else...[
                        Image.file(File(result[0]), height: 160, width: 180, fit: BoxFit.cover,)
                      ],
                      ElevatedButton(onPressed: () async {
                        result = await Navigator.of(context).pushNamed(TakePictureScreen.routeName);
                        setState(() {  });

                      }, child: Icon(Icons.camera))

                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
