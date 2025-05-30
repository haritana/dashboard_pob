import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/model/card_zone.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';

class CalculationPob {
  static Map<String, String> userLastZone = {};
  static Map<String, int> zonePOB = {
    officeDoor: 0,
    serverOfficeDoor: 0,
    croDoor: 0,
    orfDoor: 0,
    ccrDoor: 0,
    serverORFDoor: 0,
    portalDoor: 0,
  };

  static Map<String, EventCardholder> latestByCNumber = {};

  static void trackPob(List<EventCardholder> dataEvent) {
    if (dataEvent.isNotEmpty) {
      dataEvent.sort((a, b) {
        final aTime = DateTime.parse(a.occurrenceTime!.replaceAll(' ', ''));
        final bTime = DateTime.parse(b.occurrenceTime!.replaceAll(' ', ''));
        return aTime.compareTo(bTime);
      });
      for (var event in dataEvent) {
        final cnum = event.cardholderModel!.cardNumber;
        if (!latestByCNumber.containsKey(cnum)) {
          latestByCNumber[cnum!] = event;
        }
      }

      Map<String, String> lastKnownZone = {};

      for (var event in latestByCNumber.values) {
        final door = readDoor(event.message!);
        final zoneMatch = event.message!.contains(door);
        final currentZone = convertDoors(door);
        if (event.eventType == 20001) {
          if (!zoneMatch) continue;
          if (zoneMatch) {
            lastKnownZone[event.cardholderModel!.cardNumber!] = currentZone;
          }
        } else if (event.eventType == 20003) {
          if (currentZone == orfDoor) {
            lastKnownZone.remove(event.cardholderModel!.cardNumber!);
          } else {
            lastKnownZone[event.cardholderModel!.cardNumber!] = currentZone;
          }
        }
      }
    }
  }

  static String convertDoors(String door) {
    final msgDoor = readDoor(door);
    if (msgDoor == gallagherDoorOffice) {
      return officeDoor;
    } else if (msgDoor == gallagherDoorServerOffice) {
      return serverOfficeDoor;
    } else if (msgDoor == gallagherDoorCCR) {
      return ccrDoor;
    } else if (msgDoor == gallagherDoorInORF) {
      return orfDoor;
    } else if (msgDoor == gallagherDoorOutORF) {
      return orfDoor;
    } else if (msgDoor == gallagherDoorServerORF) {
      return serverORFDoor;
    } else if (msgDoor == gallagherDoorCRO) {
      return croDoor;
    }
    return msgDoor;
  }

  static String readDoor(String message) {
    return message.split('through').last.trim();
  }

  static getPob() => zonePOB.forEach((zone, count) {
        if (zonePOB.containsKey(zone)) {
          zonePOB[zone] = zonePOB[zone]! + 1;
        }
      });

  static List<CardZonaModel> getPOBPerDoor(List<EventCardholder> dataEvent) {
    trackPob(dataEvent);
    return zonePOB.entries
        .map((entry) => CardZonaModel(
              title: entry.key,
              value: '${entry.value}',
              color: entry.key == 'Office' || entry.key == 'ORF Area'
                  ? yellowZone
                  : redZone,
            ))
        .toList();
  }
}
