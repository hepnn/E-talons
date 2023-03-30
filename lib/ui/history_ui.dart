import 'package:etalons/models/etalons.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HistoryUI extends StatefulWidget {
  const HistoryUI({super.key});

  @override
  State<HistoryUI> createState() => _HistoryUIState();
}

class _HistoryUIState extends State<HistoryUI> {
  @override
  Widget build(BuildContext context) {
    final historyBox = Hive.box<Etalons>('history');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: historyBox.isEmpty
          ? const Center(
              child: Text(
              'Scanned E-talons will appear here',
              style: TextStyle(fontSize: 20),
            ))
          : SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          historyBox.clear();
                          setState(() {});
                        },
                        child: const Text('Delete all')),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: historyBox.length,
                    itemBuilder: (context, index) {
                      final etalon = historyBox.getAt(index)!;
                      final Map<String, Color> busTypeToColor = {
                        '08': Colors.yellowAccent[700]!,
                        '09': Colors.redAccent[700]!,
                        '0A': Colors.blueAccent[700]!,
                      };
                      Color firstBusColor =
                          busTypeToColor[etalon.firstBusType] ??
                              Colors.transparent;
                      Color secondBusColor =
                          busTypeToColor[etalon.secondBusType] ??
                              Colors.transparent;

                      return ExpandableNotifier(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              child: Text(etalon.timeScanned.toString()),
                            ),
                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(etalon.id,
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
                                    child: Container(
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Text(
                                              etalon.getRemainingTrips
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 24)),
                                          const Text('  /  ',
                                              style: TextStyle(fontSize: 24)),
                                          Text(etalon.getTotalTrips.toString(),
                                              style: const TextStyle(
                                                  fontSize: 24)),
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
                                            ExpandablePanelHeaderAlignment
                                                .center,
                                        iconColor:
                                            Theme.of(context).iconTheme.color,
                                        tapBodyToCollapse: true,
                                        tapHeaderToExpand: etalon
                                                .secondBusNumber
                                                .toString()
                                                .isEmpty
                                            ? false
                                            : true,
                                        hasIcon: etalon.secondBusNumber
                                                .toString()
                                                .isEmpty
                                            ? false
                                            : true,
                                      ),
                                      header: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "Rides",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          )),
                                      collapsed: etalon.secondBusNumber
                                              .toString()
                                              .isEmpty
                                          ? ListTile(
                                              title: Text(etalon.firstRideTime),
                                              subtitle:
                                                  const Text('Abrenes iela'),
                                              trailing: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(2)),
                                                    color: firstBusColor,
                                                  ),
                                                  height: 20,
                                                  width: 20,
                                                  child: Center(
                                                      child: Text(
                                                          etalon.firstBusNumber,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .white)))),
                                            )
                                          : ListTile(
                                              title:
                                                  Text(etalon.secondRideTime),
                                              subtitle:
                                                  const Text('Abrenes iela'),
                                              trailing: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(2)),
                                                  color: secondBusColor,
                                                ),
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                    child: Text(
                                                        etalon.secondBusNumber,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white))),
                                              ),
                                            ),
                                      expanded: etalon.secondBusNumber
                                              .toString()
                                              .isEmpty
                                          ? const SizedBox.shrink()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(
                                                      etalon.secondRideTime),
                                                  subtitle: const Text(
                                                      'Abrenes iela'),
                                                  trailing: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  2)),
                                                      color: secondBusColor,
                                                    ),
                                                    height: 20,
                                                    width: 20,
                                                    child: Center(
                                                        child: Text(
                                                            etalon
                                                                .secondBusNumber,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      etalon.firstRideTime),
                                                  subtitle: const Text(
                                                      'Abrenes iela'),
                                                  trailing: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    2)),
                                                        color: firstBusColor,
                                                      ),
                                                      height: 20,
                                                      width: 20,
                                                      child: Center(
                                                          child: Text(
                                                              etalon
                                                                  .firstBusNumber,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white)))),
                                                ),
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
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
