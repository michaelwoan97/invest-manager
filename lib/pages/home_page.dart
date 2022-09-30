import 'package:firebase_auth/firebase_auth.dart';
import 'package:invest_manager/controllers/auth.dart';
import 'package:flutter/material.dart';
import 'package:invest_manager/controllers/custom_auth.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/add_stock.dart';
import 'package:invest_manager/pages/login_register_page.dart';
import 'package:invest_manager/pages/widget_tree.dart';
import 'package:invest_manager/controllers/mangement_API.dart';
import 'package:invest_manager/utils/read_json_file.dart';
import 'package:invest_manager/widgets/stock_list.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;
import '../models/sneaker.dart';
import '../utils/mange_token.dart';

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
  final User? user = Auth().currentUser;
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
    await AuthService().logOut(SneakerManager().refreshToken);
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
                if (dropDownValue == Type.sneaker) {
                  Navigator.of(context).pushNamed(AddStock.routeName);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _title() {
    return const Text('Home');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User Email');
  }

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

  Widget _HomeInventory() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(greetingMsg),
            Container(
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
                            Text(
                              'Total Products',
                              style: TextStyle(color: Colors.green),
                            ),
                            Text(SneakerManager().totalAvaiProducts.toString())
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
                            Text('Products Sold',
                                style: TextStyle(color: Colors.red)),
                            Text(SneakerManager().totalSoldProducts.toString())
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
        title: _title(),
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
              SneakerManager().calculateTotalProductSold();
              SneakerManager().calculateTotalQuantityProducts();
              return _HomeInventory();
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showTypeDialog();
        },
      ),
    );
  }
}
