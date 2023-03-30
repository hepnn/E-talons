import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'etalons.g.dart';

@HiveType(typeId: 0)
class Etalons extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String firstBusNumber;
  @HiveField(2)
  final String secondBusNumber;
  @HiveField(3)
  final String firstBusType;
  @HiveField(4)
  final String secondBusType;
  @HiveField(5)
  final String firstRideTime;
  @HiveField(6)
  final String secondRideTime;
  @HiveField(7)
  final String getTotalTrips;
  @HiveField(8)
  final String getRemainingTrips;
  @HiveField(9)
  final String timeScanned =
      DateFormat('yyyy-MM-dd, HH:MM').format(DateTime.now());

  Etalons({
    required this.id,
    required this.firstBusNumber,
    required this.secondBusNumber,
    required this.firstBusType,
    required this.secondBusType,
    required this.firstRideTime,
    required this.secondRideTime,
    required this.getTotalTrips,
    required this.getRemainingTrips,
  });

  factory Etalons.fromJson(Map<String, dynamic> json) {
    return Etalons(
      id: json['cardId'].toString(),
      firstBusNumber: json['firstBusNumber'].toString(),
      secondBusNumber: json['secondBusNumber'].toString(),
      firstBusType: json['firstBusType'].toString(),
      secondBusType: json['secondBusType'].toString(),
      firstRideTime: json['firstRideTime'].toString(),
      secondRideTime: json['secondRideTime'].toString(),
      getTotalTrips: json['getTotalTrips'].toString(),
      getRemainingTrips: json['getRemainingTrips'].toString(),
    );
  }
}
