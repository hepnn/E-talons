import 'package:etalons/widgets/ride_listtile_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/etalons.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => ScanViewState();
}

class ScanViewState extends State<ScanView> {
  final MethodChannel _methodChannel = const MethodChannel('com.etalons.nfc');
  late Box<Etalons> _historyBox;
  Map<String, dynamic> _nfcData = {};

  bool _isLoading = false;

  Future<void> _scanNfc() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _methodChannel.invokeMethod('scanNfc');
      print('invoked scanNfc');
    } on PlatformException catch (e) {
      print('Error scanning NFC tag: ${e.message}');
    } finally {
      setState(() {});
    }
  }

  void _onNfcScanned(nfcData) async {
    setState(() {
      _nfcData = Map.from(nfcData);
      _isLoading = false;
    });

    final etalon = Etalons.fromJson(_nfcData);

    // Check if card already exists in history
    final existingCards =
        _historyBox.values.where((card) => card.id == etalon.id);

    if (existingCards.isNotEmpty) {
      // Delete old card from history
      await _historyBox.delete(existingCards.first.key);
    }

    // Add new card to history
    await _historyBox.add(etalon);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initHive();
    _methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.resetAdapters(); // an error occurs without resetting the adapters
    Hive.registerAdapter(EtalonsAdapter());
    _historyBox = await Hive.openBox<Etalons>('history');
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onNfcScanned':
        _onNfcScanned(call.arguments);
        break;
      default:
        print('Unknown method ${call.method}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Etalons busData = Etalons.fromJson(_nfcData);

    final Map<String, Color> busTypeToColor = {
      '08': Colors.yellowAccent[700]!,
      '09': Colors.redAccent[700]!,
      '0A': Colors.blueAccent[700]!,
    };

    Color firstBusColor =
        busTypeToColor[busData.firstBusType] ?? Colors.transparent;
    Color secondBusColor =
        busTypeToColor[busData.secondBusType] ?? Colors.transparent;
    return Scaffold(
      floatingActionButton: SpeedDial(
        childMargin: const EdgeInsets.all(24),
        icon: Icons.info_outline,
        activeIcon: Icons.close,
        activeForegroundColor: Colors.white,
        buttonSize: const Size(56, 56),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.send),
            label: 'Send dump',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () => print('send email containing data dump'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.question_mark),
            label: 'About',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () => print('about dialog'),
          ),

          //add more menu item childs here
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpandableNotifier(
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: 500,
                  child: _isLoading
                      ? SizedBox(
                          height: 360,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(height: 20),
                              Text('Scanning...'),
                              SizedBox(height: 20),
                              Text(
                                  'Please hold the back of your phone near the E-talon'),
                            ],
                          ),
                        )
                      : _nfcData.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _nfcData = {};
                                  _isLoading = true;
                                  _scanNfc();
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  SvgPicture.asset(
                                    colorFilter: const ColorFilter.mode(
                                        Colors.grey, BlendMode.srcIn),
                                    'assets/contactless-icon.svg',
                                    height: 130,
                                  ),
                                  const SizedBox(height: 60),
                                  Text('Tap to start scanning for E-talons',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  const SizedBox(
                                    height: 70,
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(busData.id,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, bottom: 12, right: 12),
                                  child: Row(
                                    children: [
                                      Text('Tickets',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      const Spacer(),
                                      const Text('Purchase date',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12),
                                  child: SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Text(
                                            busData.getRemainingTrips
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 24)),
                                        const Text('  /  ',
                                            style: TextStyle(fontSize: 24)),
                                        Text(busData.getTotalTrips.toString(),
                                            style:
                                                const TextStyle(fontSize: 24)),
                                        const Spacer(),
                                        const Text('2021-05-05'),
                                      ],
                                    ),
                                  ),
                                ),
                                ScrollOnExpand(
                                  scrollOnExpand: true,
                                  scrollOnCollapse: false,
                                  child: ExpandablePanel(
                                    theme: ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      iconColor:
                                          Theme.of(context).iconTheme.color,
                                      tapBodyToCollapse: true,
                                      tapHeaderToExpand: busData.secondBusNumber
                                              .toString()
                                              .isEmpty
                                          ? false
                                          : true,
                                      hasIcon: busData.secondBusNumber
                                              .toString()
                                              .isEmpty
                                          ? false
                                          : true,
                                    ),
                                    header: busData.secondBusNumber.isEmpty &&
                                            busData.firstBusNumber.isEmpty
                                        ? null
                                        : Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              "Rides",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            )),
                                    collapsed: busData.secondBusNumber
                                            .toString()
                                            .isEmpty
                                        ? RideListTile(
                                            titleText: busData.firstRideTime,
                                            busColor: firstBusColor,
                                            busNumber: busData.firstBusNumber,
                                          )
                                        : RideListTile(
                                            titleText: busData.secondRideTime,
                                            busColor: secondBusColor,
                                            busNumber: busData.secondBusNumber,
                                          ),
                                    expanded: busData.secondBusNumber
                                            .toString()
                                            .isEmpty
                                        ? const SizedBox.shrink()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              RideListTile(
                                                titleText:
                                                    busData.secondRideTime,
                                                busColor: secondBusColor,
                                                busNumber:
                                                    busData.secondBusNumber,
                                              ),
                                              RideListTile(
                                                titleText:
                                                    busData.firstRideTime,
                                                busColor: firstBusColor,
                                                busNumber:
                                                    busData.firstBusNumber,
                                              )
                                            ],
                                          ),
                                    builder: (_, collapsed, expanded) {
                                      return Expandable(
                                        collapsed: collapsed,
                                        expanded: expanded,
                                        theme: const ExpandableThemeData(
                                          crossFadePoint: 0,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    minimumSize: const Size(double.infinity, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: _isLoading
                      ? () {
                          setState(() {
                            _isLoading = false;
                            _nfcData = {};
                          });
                        }
                      : () {
                          setState(() {
                            _nfcData = {};
                            _isLoading = true;
                            _scanNfc();
                          });
                        },
                  child: _isLoading ? const Text('Cancel') : const Text('Scan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
