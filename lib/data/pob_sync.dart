
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

// Hitung POB & simpan zona terakhir
      //int pob = 0;
      Map<String, String> lastKnownZone = {};

      for (var event in latestByCNumber.values) {
        final door = readDoor(event.message!);
        final zoneMatch = event.message!.contains(door);
        final currentZone = convertDoors(door);
        if (event.eventType == 20001) {
          //pob++;
          if (!zoneMatch) continue;
          // final currentZone = convertDoors(door);
          if (zoneMatch) {
            lastKnownZone[event.cardholderModel!.cardNumber!] = currentZone;
          }
        } else if (event.eventType == 20003) {
          if (currentZone == orfDoor) {
            lastKnownZone.remove(event.cardholderModel!.cardNumber!);
           // pob--;
          } else {
            lastKnownZone[event.cardholderModel!.cardNumber!] = currentZone;
          }
        }
      }

      // // print('Total POB: $pob');
      // lastKnownZone.forEach((cnum, zone) {
      //   //print('$cnum berada di $zone');

      // });

      // Reset semua zone count ke 0
// static int countPOB()=>zonePOB.updateAll((key, value) => 0);

// // Hitung berdasarkan zone terakhir user
// lastKnownZone.forEach((cnum, zone) {
//   // Pastikan nama zona cocok dengan key di zonePOB
//   if (zonePOB.containsKey(zone)) {
//     zonePOB[zone] = zonePOB[zone]! + 1;
//   } else {
//     print('Zone tidak dikenali: $zone dari user $cnum');
//   }
// });

      // dataEvent.sort((a, b) => DateTime.parse(a.occurrenceTime!)
      //     .compareTo(DateTime.parse(b.occurrenceTime!)));
      // dataEvent.sort((a, b) {
      //   final aTime = DateTime.parse(a.occurrenceTime!.replaceAll(' ', ''));
      //   final bTime = DateTime.parse(b.occurrenceTime!.replaceAll(' ', ''));
      //   return aTime.compareTo(bTime);
      // });

      // for (var pob in dataEvent) {
      //   final door =
      //       readDoor(pob.message!); //through Barrier Gate OUT - Old Building
      //   final zoneMatch = pob.message!.contains(door);
      //   if (!zoneMatch) continue;

      //   final currentZone = convertDoors(door);
      //   final lastZone = userLastZone[pob.cardNumber];
      //   if (pob.eventType == 20001) {
      //     // ENTRY
      //     if (lastZone != null && zonePOB.containsKey(lastZone)) {
      //       zonePOB[lastZone] =
      //           zonePOB[lastZone]! - 1; // keluar dari zona sebelumnya
      //     }
      //     zonePOB[currentZone] =
      //         (zonePOB[currentZone] ?? 0) + 1; // masuk zona baru
      //     userLastZone[pob.cardNumber!] = currentZone; // update lokasi terakhir
      //   } else if (pob.eventType == 20003) {
      //     // EXIT
      //     zonePOB[currentZone] =
      //         (zonePOB[currentZone] ?? 0) - 1; // keluar dari zona sekarang

      //     // Misalnya kita tahu user kembali ke zona sebelumnya (simulasi default ke Office1)
      //     final fallbackZone =
      //         currentZone.contains(officeDoor) ? currentZone : officeDoor;
      //     print('fallbackZone: $fallbackZone');
      //     zonePOB[fallbackZone] = (zonePOB[fallbackZone] ?? 0) + 1;
      //     userLastZone[pob.cardNumber!] =
      //         fallbackZone; // update lokasi terakhir
      //   }
      // }
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
        } else {
          //print('Zone tidak dikenali: $zone dari user $cnum');
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


// for (var pob in dataEvent) {
  //   final door = readDoor(pob.message!);
  //   final isEntry = pob.eventType == 20001;
  //   final convDoors = convertDoors(door);

  //   if (staticDoors.containsKey(convDoors) && isEntry) {
  //     if (userLocation.containsKey(pob.ftItemId)) {
  //       final prevDoor = userLocation[pob.ftItemId]!;
  //       if (staticDoors.containsKey(prevDoor)) {
  //         staticDoors[prevDoor] =
  //             (staticDoors[prevDoor]! > 0) ? staticDoors[prevDoor]! - 1 : 0;
  //       }
  //     }

  //     userLocation[pob.ftItemId!] = convDoors;
  //     staticDoors[convDoors] = (staticDoors[convDoors] ?? 0) + 1;
  //   }
  // }

  // static void processExit(List<EventCardholder> dataEvent) {
  //   if (dataEvent.isNotEmpty) {
  //     for (var pob in dataEvent) {
  //       final door = readDoor(pob.message!);
  //       final convDoors = convertDoors(door);
  //       final isExit = pob.eventType == 20003;
  //       if (staticDoors.containsKey(convDoors) &&
  //           userLocation.containsKey(pob.ftItemId) &&
  //           userLocation[pob.ftItemId] == convDoors &&
  //           isExit) {
  //         staticDoors[convDoors] =
  //             (staticDoors[convDoors]! > 0) ? staticDoors[convDoors]! - 1 : 0;

  //         if (convDoors == serverOfficeDoorStatic ||
  //             convDoors == croDoorStatic) {
  //           userLocation[pob.ftItemId!] = officeDoorStatic;
  //           staticDoors[officeDoorStatic] =
  //               (staticDoors[officeDoorStatic] ?? 0) + 1;
  //         } else if (convDoors == ccrDoorStatic ||
  //             convDoors == serverORFDoorStatic) {
  //           userLocation[pob.ftItemId!] = orfDoorStatic;
  //           staticDoors[orfDoorStatic] = (staticDoors[orfDoorStatic] ?? 0) + 1;
  //         } else {
  //           userLocation.remove(pob.ftItemId);
  //         }
  //       }
  //     }
  //   }
  // }

  // static int getCurrentPOB() {
  //   return staticDoors.values.fold(0, (sum, count) => sum + count);
  // }

  // List<CardZonaModel> getPOBPerDoorTest(List<EventCardholder> dataEvent) {
  //   processEntry(dataEvent);
  //   processExit(dataEvent);
  //   return staticDoors.entries
  //       .map((entry) => CardZonaModel(
  //             title: entry.key,
  //             value: '${entry.value}',
  //             color: entry.key == 'Office' || entry.key == 'ORF Area'
  //                 ? yellowZone
  //                 : redZone,
  //           ))
  //       .toList();
  // }

// List<EventCardholder> fake = [
//   EventCardholder(
//       ftItemId: 1, message: 'through $doorOffice', eventType: 20001),
//   EventCardholder(
//       ftItemId: 1, message: 'through $doorServerOffice', eventType: 20001),
  // EventCardholderFake(
  //     ftItemId: 2, message: 'through $doorInORF', eventType: 20001),
  // EventCardholderFake(
  //     ftItemId: 3, message: 'through $doorServerOffice', eventType: 20001),
  // EventCardholderFake(
  //     ftItemId: 4, message: 'through $doorServerORF', eventType: 20001),
  // EventCardholderFake(
  //     ftItemId: 5, message: 'through $doorCRO', eventType: 20001),
  // EventCardholderFake(
  //     ftItemId: 6, message: 'through $doorCCR', eventType: 20001),
  // EventCardholderFake(
  //    ftItemId: 7, message: 'through $doorOffice', eventType: 20001),
  // EventCardholderFake(
  //     ftItemId: 8, message: 'through $doorCCR', eventType: 20001),
  // EventCardholderFake(
  //     ftItemId: 9, message: 'through $doorServerORF', eventType: 20001),
  // EventCardholderFake(
  //     ftItemId: 10, message: 'through $doorOffice', eventType: 20003),
  // EventCardholderFake(
  //     ftItemId: 11, message: 'through $doorCCR', eventType: 20003),
  // EventCardholderFake(
  //     ftItemId: 12, message: 'through $doorServerORF', eventType: 20003),
  // EventCardholderFake(
  //     ftItemId: 13, message: 'through $doorOffice', eventType: 20001),
  // EventCardholderFake(
  //     ftItemId: 14, message: 'through $doorCCR', eventType: 20001),
// ];

// class EventCardholderFake {
//   const EventCardholderFake(
//       {required this.ftItemId, required this.message, required this.eventType});
//   final int ftItemId;
//   final String message;
//   final int eventType;