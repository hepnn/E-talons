import 'package:flutter/material.dart';

class RideListTile extends StatelessWidget {
  final String titleText;
  final Color busColor;
  final String busNumber;

  const RideListTile(
      {super.key,
      required this.titleText,
      required this.busColor,
      required this.busNumber});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(titleText),
      subtitle: const Text('Abrenes iela'),
      trailing: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            color: busColor,
          ),
          height: 20,
          width: 20,
          child: Center(
              child: Text(busNumber,
                  style: const TextStyle(color: Colors.white)))),
    );
  }
}
