import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invest_manager/controllers/mangement_API.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/take_picture_page.dart';
import 'package:invest_manager/styles/max_width_container.dart';
import 'package:invest_manager/styles/responsive/breakpoints.dart';
import 'package:invest_manager/styles/responsive/font_sizes.dart';
import 'package:invest_manager/styles/responsive_layout.dart';
import 'package:invest_manager/widgets/custom_sneaker_image.dart';
import 'package:invest_manager/widgets/sneaker_stock_list.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/sneaker.dart';
import '../styles/theme_styles.dart';

enum Scenarios { add, edit }

/*
* class: AddStock
* purpose: This class represent the add stock page
* */
class AddStock extends StatefulWidget {
  static const routeName = '/home/stock-info';
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

  /*
  * purpose: when the app uses on web browser, no camera available. An alert will be presented to the users
  * */
  Future<void> _alertImageDesktop() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Attention!!!"),
          content: SingleChildScrollView(
            child: Text(
                "A version allows to take or select a picture from camera will be added in the near future. Sorry for the inconvenience!"),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"))
          ],
        );
      },
    );
  }

  void _processNewImages(Sneaker sneaker, String filePath) async {
    if (filePath.isEmpty) {
      print("File not existed!!!");
      return;
    }

    Uri myUri = Uri.parse(filePath);
    File imageFile = new File.fromUri(myUri);
    Uint8List bytes;
    String convertedImage = "";
    await imageFile.readAsBytes().then((val) {
      bytes = Uint8List.fromList(val);
      convertedImage = base64Encode(val);

      if (convertedImage.isNotEmpty) {
        result = convertedImage;
        // check scenario
        if (widget.scenarios == Scenarios.edit) {
          // using result variables update temporarily the image
          // taken from camera so not update anywhere else
          sneaker.notifyWithoutUpdateData();
        } else {
          sneaker.updateImgURLNotify(result);
        }
      }
      print("image read as bytes: " + convertedImage);
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments == null ||
        (ModalRoute.of(context)!.settings.arguments as List).isEmpty) {
      // check whether image is available
      if(result != null){
        widget.newSneaker = Sneaker(sID: uuid.v1(), sName: '', sImageUrl: result);
      } else {
        widget.newSneaker = Sneaker(sID: uuid.v1(), sName: '');
      }

    } else {
      final sneakerData = ModalRoute.of(context)!.settings.arguments as List;

      widget.newSneaker = sneakerData[0] as Sneaker;
      widget.scenarios = sneakerData[1] as Scenarios;
      _sneakerNameController.text = widget.newSneaker.getSneakerName;
      result = widget.newSneaker.getImgUrl;
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height >= kTabletBreakPoint
                  ? 60
                  : MediaQuery.of(context).size.height * 0.1),
          child: MaxWidthContainer(
            child: AppBar(
              title: Text('Stock Info',
                  style: MediaQuery.of(context).size.width > kTabletBreakPoint
                      ? AppTheme.kFontSizeDesktopAppBarText
                      : AppTheme.kFontSizeMobileAppBarText),
              actions: [
                IconButton(
                    onPressed: () {
                      widget.newSneaker.clearAvailableStockExisted();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close_sharp))
              ],
            ),
          ),
        ),
        body: ChangeNotifierProvider.value(
          value: widget.newSneaker,
          builder: (context, child) => Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: MaxWidthContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 5,
                              child: ResponsiveLayout(
                                mobileBody: _formSneakerMobile(),
                                tabletVersion: _formSneakerDesktop(),
                                desktopVersion: _formSneakerDesktop(),
                              )),
                          Spacer(
                            flex: 1,
                          ),
                          Consumer<Sneaker>(
                            builder: (ctx, sneaker, _) => Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  if (result == null &&
                                      widget.newSneaker.getImgUrl.isEmpty) ...[
                                    Text('Use camera to take picture')
                                  ] else ...[
                                    Expanded(
                                      flex: 4,
                                      child: CustomSneakerImage(
                                        images: result,
                                        placeholderImg:
                                            "assets/images/default_img.png",
                                      ),
                                    )
                                  ],
                                  Row(
                                    children: [
                                      Spacer(
                                        flex: 3,
                                      ),
                                      if (kIsWeb) ...[
                                        Expanded(
                                          flex: 3,
                                          child: ElevatedButton(
                                              onPressed: _alertImageDesktop,
                                              child: Icon(Icons.camera)),
                                        )
                                      ] else ...[
                                        Expanded(
                                          flex: 3,
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                result =
                                                    await Navigator.of(context)
                                                        .pushNamed(
                                                            TakePictureScreen
                                                                .routeName);
                                                result = result[0].toString();
                                                _processNewImages(
                                                    sneaker, result);
                                              },
                                              child: Icon(Icons.camera)),
                                        )
                                      ],
                                      Spacer(
                                        flex: 3,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.scenarios == Scenarios.edit) ...[
                      Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: SneakerStockList(
                              scenarioProcessing: Scenarios.edit))
                    ] else ...[
                      Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: SneakerStockList(
                              scenarioProcessing: Scenarios.add))
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: MaxWidthContainer(
          child: Container(
            width: double.infinity,
            padding: MediaQuery.of(context).size.width >= kMaxWidth
                ? EdgeInsets.only(left: 0, right: 0)
                : EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment:
                  MediaQuery.of(context).size.width >= kTabletBreakPoint
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // validate Form
                    if (_formKey.currentState!.validate()) {
                      // check whether adding or editing stocks
                      _processStockInfoRequests();
                    }
                  },
                  child: widget.scenarios == Scenarios.add
                      ? Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Center(
                                child: AutoSizeText(
                                  "+ Add to the List",
                                  style: MediaQuery.of(context).size.width >
                                          kTabletBreakPoint
                                      ? AppTheme.kFontSizeDesktopAppBarText
                                      : AppTheme.kFontSizeMobileAppBarText,
                                ),
                              ),
                            )
                          ],
                        )
                      : Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Center(
                                child: AutoSizeText(
                                  "Edit Sneaker Info!!",
                                  style: MediaQuery.of(context).size.width >
                                          kTabletBreakPoint
                                      ? AppTheme.kFontSizeDesktopAppBarText
                                      : AppTheme.kFontSizeMobileAppBarText,
                                ),
                              ),
                            )
                          ],
                        ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  void _processStockInfoRequests() {
    // check whether adding or editing stocks
    if (widget.scenarios == Scenarios.edit) {
      // update sneaker
      widget.newSneaker.updateSneaker(
          newSneakerName: _sneakerNameController.text,
          sNewNotes: _sneakerNotesController.text,
          sNewImgURL: result);
      ManagementAPI().updateSneaker(SneakerManager().accessToken,
          SneakerManager().userID, widget.newSneaker.getID, widget.newSneaker);
    } else {
      widget.newSneaker.setSneakerName = _sneakerNameController.text;
      if (_sneakerNotesController.text.isNotEmpty) {
        widget.newSneaker.setNotes = _sneakerNotesController.text;
      }

      //update new sneaker total
      double totalNewSneakerPrice = 0;
      // check whether new stocks available
      if (widget.newSneaker.getAvailableStocks.isNotEmpty) {
        for (var e in widget.newSneaker.getAvailableStocks) {
          if (e.getSneakerSoldPrice.isEmpty) {
            continue;
          }
          totalNewSneakerPrice += double.parse(e.getSneakerSoldPrice);
        }
      }
      // update available products
      SneakerManager().updateTotalAvaiSoldProducts(
          widget.newSneaker.getAvailableStocks.length, totalNewSneakerPrice);

      SneakerManager().addNewSneakerToList(widget.newSneaker);
      ManagementAPI().addSneaker(SneakerManager().accessToken,
          SneakerManager().userID, widget.newSneaker);
    }

    widget.newSneaker.clearAvailableStockExisted();
    Navigator.of(context).pop();
  }

  /*
  * purpose: different layout when the app reach mobile breakpoints
  * */
  Widget _formSneakerMobile() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: _sneakerNameController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the stock's name";
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "Sneaker Name",
                labelStyle: TextStyle(fontSize: kMobileInputText)),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
              controller: _sneakerNotesController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                  labelText: "Notes",
                  labelStyle: TextStyle(fontSize: kMobileInputText))),
        ),
        Spacer(
          flex: 4,
        )
      ],
    );
  }

  /*
  * purpose: different layout when the app reach desktop/tablet breakpoints
  * */
  Widget _formSneakerDesktop() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: _sneakerNameController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the stock's name";
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "Sneaker Name",
                labelStyle: TextStyle(fontSize: kDesktopInputText)),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
              controller: _sneakerNotesController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                  labelText: "Notes",
                  labelStyle: TextStyle(fontSize: kDesktopInputText))),
        ),
        Spacer(
          flex: 4,
        )
      ],
    );
  }
}
