import 'package:auto_size_text/auto_size_text.dart';
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

/*
* class: HomePage
* purpose: This class represent the HomePage page
* */
class HomePage extends StatefulWidget {
  static const routeName = '/home';

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Type dropDownValue = Type.sneaker;
  late Future<List<Sneaker>> listSneakers;

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

  /*
  * purpose: check which value is selected from the drop down widget
  * */
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
    SneakerManager().isTotalCalculated = false;
    await AuthService()
        .logOut(SneakerManager().refreshToken, SneakerManager().userID);
  }

  /*
  * purpose: create dialog with choices to select
  * */
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
        style: MediaQuery.of(context).size.width > kTabletBreakPoint
            ? AppTheme.kFontSizeDesktopAppBarText
            : AppTheme.kFontSizeMobileAppBarText);
  }

  /*
  * purpose: create dropdown widget
  * */
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

  /*
  * purpose: different layout when the app reach mobile breakpoints
  * */
  Widget _HomeInventoryMobile() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              greetingMsg,
              style: AppTheme.displayInvenTitle(context, kMobileHeadings),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height >= kTabletBreakPoint
                  ? 180
                  : MediaQuery.of(context).size.height * 0.2,
              child: Container(
                width: double.infinity,
                child: Consumer<SneakerManager>(
                  builder: (ctx, manager, _) => Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Expanded(
                                child: AutoSizeText(
                                  'Total Products',
                                  style: AppTheme.totalInvenTitle(context,
                                      Colors.green, kMobileSubHeadings),
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                    SneakerManager()
                                        .totalAvaiProducts
                                        .toString(),
                                    style: AppTheme.totalInvenTitle(context,
                                        Colors.black, kMobileSubHeadings)),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 2,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Expanded(
                                  child: AutoSizeText('Products Sold',
                                      style: AppTheme.totalInvenTitle(context,
                                          Colors.red, kMobileSubHeadings)),
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                      SneakerManager()
                                          .totalSoldProducts
                                          .toString(),
                                      style: AppTheme.totalInvenTitle(context,
                                          Colors.black, kMobileSubHeadings)),
                                ),
                                Spacer()
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                child: StockList())
          ],
        ),
      ),
    );
  }

  /*
  * purpose: different layout when the app reach mobile breakpoints
  * */
  Widget _HomeInventoryDesktop() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              greetingMsg,
              style: AppTheme.displayInvenTitle(context, kDesktopHeadings),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height >= kTabletBreakPoint
                  ? 180
                  : MediaQuery.of(context).size.height * 0.2,
              child: Container(
                width: double.infinity,
                child: Consumer<SneakerManager>(
                  builder: (ctx, manager, _) => Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Expanded(
                                child: AutoSizeText(
                                  'Total Products',
                                  style: AppTheme.totalInvenTitle(context,
                                      Colors.green, kDesktopSubHeadings),
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                    SneakerManager()
                                        .totalAvaiProducts
                                        .toString(),
                                    style: AppTheme.totalInvenTitle(context,
                                        Colors.black, kDesktopSubHeadings)),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 2,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Expanded(
                                  child: AutoSizeText('Products Sold',
                                      style: AppTheme.totalInvenTitle(context,
                                          Colors.red, kDesktopSubHeadings)),
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                      SneakerManager()
                                          .totalSoldProducts
                                          .toString(),
                                      style: AppTheme.totalInvenTitle(context,
                                          Colors.black, kDesktopSubHeadings)),
                                ),
                                Spacer()
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height >= kTabletBreakPoint
                    ? 500
                    : MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    Expanded(child: StockList()),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height >= kTabletBreakPoint
                ? 60
                : MediaQuery.of(context).size.height * 0.1),
        child: MaxWidthContainer(
          child: AppBar(
            title: _title(context),
            actions: [
              IconButton(
                icon: Icon(Icons.logout_outlined),
                onPressed: () {
                  signOut();
                  Navigator.of(context)
                      .pushReplacementNamed(LoginPage.routeName);
                },
              )
            ],
          ),
        ),
      ),
      body: ChangeNotifierProvider.value(
        value: sneakerManager,
        child: FutureBuilder<List<Sneaker>>(
          future: listSneakers,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              // check whether the app has fetched sneakers for the first time
              if (!SneakerManager().fetchedSneakers) {
                List<Sneaker> sneakers = snapshot.data!;
                // add list to singleton provider
                sneakerManager.setListSneaker = sneakers;
                SneakerManager().fetchedSneakers = true;
              }

              // check whether the total is calculated so it would be not
              if (!SneakerManager().isTotalCalculated) {
                SneakerManager().calculateTotalProductSold();
                SneakerManager().calculateTotalQuantityProducts();
                SneakerManager().isTotalCalculated = true;
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
          crossAxisAlignment:
              MediaQuery.of(context).size.width >= kTabletBreakPoint
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _showTypeDialog();
              },
            )
          ],
        ),
      ),
    );
  }
}
