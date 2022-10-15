import 'package:firebase_auth/firebase_auth.dart';
import 'package:invest_manager/controllers/auth.dart';
import 'package:flutter/material.dart';
import 'package:invest_manager/controllers/custom_auth.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/add_stock.dart';
import 'package:invest_manager/pages/login_register_page.dart';
import 'package:invest_manager/pages/widget_tree.dart';
import 'package:invest_manager/controllers/mangement_API.dart';
import 'package:invest_manager/styles/max_width_container.dart';
import 'package:invest_manager/styles/responsive/font_sizes.dart';
import 'package:invest_manager/styles/responsive_layout.dart';
import 'package:invest_manager/styles/theme_styles.dart';
import 'package:invest_manager/utils/read_json_file.dart';
import 'package:invest_manager/widgets/stock_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as io;
import '../models/sneaker.dart';
import '../styles/responsive/breakpoints.dart';
import '../utils/mange_token.dart';
import '../widgets/transition_routes.dart';

enum Type { sneaker, electronic, crypto }

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Type dropDownValue = Type.sneaker;
  late Future<List<Sneaker>> listSneakers;
  bool isCalculated = false;

  // final User? user = Auth().currentUser;
  final SneakerManager sneakerManager = SneakerManager();
  late String greetingMsg;

  @override
  void initState() {
    super.initState();

    // listSneakers = ReadJsonFile.readJson("../../assets/data/sneaker_data.json");
    listSneakers = ManagementAPI().getSneakers(SneakerManager().accessToken);
    DateTime now = DateTime.now();
    int hours = now.hour;

    if (hours >= 1 && hours <= 12) {
      greetingMsg = "Good Morning!";
    } else if (hours >= 12 && hours <= 16) {
      greetingMsg = "Good Afternoon!";
    } else if (hours >= 16 && hours <= 21) {
      greetingMsg = "Good Evening!";
    } else if (hours >= 21 && hours <= 24) {
      greetingMsg = "Good Night!";
    }
  }

  String _checkTypeOfDropdownValue(Type kind) {
    switch (kind) {
      case Type.sneaker:
        {
          return 'Sneakers';
        }
      case Type.electronic:
        {
          return 'Electronics';
        }
      case Type.crypto:
        {
          return 'Crypto';
        }
      default:
        {
          return 'Error!!!';
        }
    }
  }

  Future<void> signOut() async {
    SneakerManager().totalAvaiProducts = 0;
    SneakerManager().totalSoldProducts = 0.0;
    await AuthService()
        .logOut(SneakerManager().refreshToken, SneakerManager().userID);
  }

  Future<void> _showTypeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Type of Inventory'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('what kind of stock are you adding to your inventory?'),
                _dropDownTypesButton(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
                if (dropDownValue == Type.sneaker) {
                  // Navigator.of(context).pushNamed(AddStock.routeName);
                  Navigator.push(
                    context,
                    TransitionRoutes(
                      page: AddStock(),
                      routeName: AddStock.routeName,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _title(BuildContext context) {
    return Text('Home',
        style: MediaQuery.of(context).size.width >
            kTabletBreakPoint
            ? AppTheme.kFontSizeDesktopAppBarText
            : AppTheme.kFontSizeMobileAppBarText);
  }

  // Widget _userUid() {
  //   return Text(user?.email ?? 'User Email');
  // }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  Widget _dropDownTypesButton() {
    String value = _checkTypeOfDropdownValue(this.dropDownValue);
    return DropdownButtonFormField<String>(
        items: const [
          DropdownMenuItem(child: Text('Sneakers'), value: 'Sneakers'),
          DropdownMenuItem(child: Text('Electronics'), value: 'Electronics'),
          DropdownMenuItem(child: Text('Crypto'), value: 'Crypto'),
        ],
        value: value,
        onChanged: (selectedValue) {
          if (selectedValue is String) {
            // check type of selected value
            if (selectedValue == 'Sneakers') {
              dropDownValue = Type.sneaker;
            } else if (selectedValue == 'Electronics') {
              dropDownValue = Type.electronic;
            } else {
              dropDownValue = Type.crypto;
            }

            setState(() {
              dropDownValue;
            });
          }
        });
  }

  Widget _HomeInventoryMobile() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              greetingMsg,
              style: AppTheme.displayInvenTitle(context, kMobileHeadings),
            ),
            Container(
              margin: AppTheme.spaceBetweenInListTop(),
              child: Consumer<SneakerManager>(
                builder: (ctx, manager, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 2,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              margin: AppTheme.spaceBetweenInListBottom(),
                              child: Text(
                                'Total Products',
                                style: AppTheme.totalInvenTitle(
                                    context, Colors.green, kMobileSubHeadings),
                              ),
                            ),
                            Text(SneakerManager().totalAvaiProducts.toString(),
                                style: AppTheme.totalInvenTitle(
                                    context, Colors.black, kMobileSubHeadings))
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              margin: AppTheme.spaceBetweenInListBottom(),
                              child: Text('\$Products Sold\$',
                                  style: AppTheme.totalInvenTitle(
                                      context, Colors.red, kMobileSubHeadings)),
                            ),
                            Text(SneakerManager().totalSoldProducts.toString(),
                                style: AppTheme.totalInvenTitle(
                                    context, Colors.black, kMobileSubHeadings))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            StockList()
          ],
        ),
      ),
    );
  }

  Widget _HomeInventoryDesktop() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              greetingMsg,
              style: AppTheme.displayInvenTitle(context, kDesktopHeadings),
            ),
            Container(
              margin: AppTheme.spaceBetweenInListTop(),
              child: Consumer<SneakerManager>(
                builder: (ctx, manager, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 2,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              margin: AppTheme.spaceBetweenInListBottom(),
                              child: Text(
                                'Total Products',
                                style: AppTheme.totalInvenTitle(
                                    context, Colors.green, kDesktopSubHeadings),
                              ),
                            ),
                            Text(SneakerManager().totalAvaiProducts.toString(),
                                style: AppTheme.totalInvenTitle(
                                    context, Colors.black, kDesktopSubHeadings))
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              margin: AppTheme.spaceBetweenInListBottom(),
                              child: Text('\$Products Sold\$',
                                  style: AppTheme.totalInvenTitle(
                                      context, Colors.red, kDesktopSubHeadings)),
                            ),
                            Text(SneakerManager().totalSoldProducts.toString(),
                                style: AppTheme.totalInvenTitle(
                                    context, Colors.black, kDesktopSubHeadings))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            StockList()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(context),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () {
              signOut();
              Navigator.of(context).pushReplacementNamed(WidgetTree.routeName);
            },
          )
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: sneakerManager,
        child: FutureBuilder<List<Sneaker>>(
          future: listSneakers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Sneaker> sneakers = snapshot.data!;
              // add list to singleton provider
              sneakerManager.setListSneaker = sneakers;

              // check whether the total is calculated so it would be not
              if(!isCalculated){
                SneakerManager().calculateTotalProductSold();
                SneakerManager().calculateTotalQuantityProducts();
                isCalculated = true;
              }

              return MaxWidthContainer(
                child: ResponsiveLayout(
                  mobileBody: _HomeInventoryMobile(),
                  tabletVersion: _HomeInventoryDesktop(),
                  desktopVersion: _HomeInventoryDesktop(),
                ),
              ); //***
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: MediaQuery.of(context).size.width >= kTabletBreakPoint ? CrossAxisAlignment.center : CrossAxisAlignment.end ,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _showTypeDialog();
            },
          )],
        ),
      ),

    );
  }
}
