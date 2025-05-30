import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/model/card_zone.dart';
import 'package:dashboard_pob/model/cardholder_model.dart';
import 'package:dashboard_pob/model/cardholder_on_zone.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';

class POBTracker {
  static const int entryEvent = 20001;
  static const int exitEvent = 20003;

  static final Map<String, int> staticDoors = {
    officeDoor: 0,
    serverOfficeDoor: 0,
    croDoor: 0,
    orfDoor: 0,
    ccrDoor: 0,
    serverORFDoor: 0,
    portalDoor: 0,
  };

  static final ValueNotifier<List<FTItemIDOnZone>> pobOnZoneNotifier =
      ValueNotifier<List<FTItemIDOnZone>>(
    staticDoors.keys
        .map((doorName) => FTItemIDOnZone(zone: doorName, ftItemId: []))
        .toList(),
  );

  static final Map<int, EventCardholder> latestByFtItemId = {};
  static final ValueNotifier<int> pobNotifier = ValueNotifier<int>(0);
  static List<CardholderModel> pobEOR = [];
  // key: ftItemId (int), value: zone (String)
  static final Map<int, String> lastKnownZone = {};

  static void processEntry(List<EventCardholder> dataEvent) {
    if (dataEvent.isEmpty) return;

    _resetData();

    final latestEvents = <int, EventCardholder>{};

    for (final event in dataEvent) {
      final ftId = event.cardholderModel?.ftItemId;
      if (ftId == null) continue;

      final eventTime = _parseDateTime(event.occurrenceTime);
      if (!latestEvents.containsKey(ftId) ||
          _parseDateTime(latestEvents[ftId]?.occurrenceTime)
              .isBefore(eventTime)) {
        latestEvents[ftId] = event;
      }
    }

    // Proses event terbaru per ftItemId
    for (final event in latestEvents.values) {
      final ftId = event.cardholderModel?.ftItemId;
      if (ftId == null) continue;

      final door = readDoor(event.message ?? '');
      final zone = convertDoors(door);

      if (event.eventType == entryEvent) {
        lastKnownZone[ftId] = zone;
        pobEOR.add(event.cardholderModel!);
      } else if (event.eventType == exitEvent) {
        _handleExitEvent(ftId, zone);
      }
    }

    _updateZoneData();
    _updatePOB();
  }

  static void _handleExitEvent(int ftId, String zone) {
    if (zone == officeDoor || zone == orfDoor) {
      lastKnownZone.remove(ftId);
      pobEOR.removeWhere((item) => item.ftItemId == ftId);
    } else if (zone == croDoor || zone == serverOfficeDoor) {
      lastKnownZone[ftId] = officeDoor;
    } else if (zone == ccrDoor || zone == serverORFDoor) {
      lastKnownZone[ftId] = orfDoor;
    }
  }

  static void _updateZoneData() {
    final currentList = List<FTItemIDOnZone>.from(pobOnZoneNotifier.value);

    for (var item in currentList) {
      item.ftItemId.clear();
    }

    lastKnownZone.forEach((ftId, zone) {
      if (staticDoors.containsKey(zone)) {
        staticDoors[zone] = (staticDoors[zone]! + 1);

        final zoneData = currentList.firstWhere(
          (element) => element.zone == zone,
          orElse: () => FTItemIDOnZone(zone: zone, ftItemId: []),
        );

        if (!zoneData.ftItemId.contains(ftId)) {
          zoneData.ftItemId.add(ftId);
        }
      }
    });

    pobOnZoneNotifier.value = currentList;
  }

  static DateTime _parseDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
    final cleaned = dateStr.replaceAll(' ', '');
    return DateTime.tryParse(cleaned) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  static void _resetData() {
    staticDoors.updateAll((key, value) => 0);
    latestByFtItemId.clear();
    pobNotifier.value = 0;
    pobEOR.clear();

    pobOnZoneNotifier.value = staticDoors.keys
        .map((doorName) => FTItemIDOnZone(zone: doorName, ftItemId: []))
        .toList();

    lastKnownZone.clear();
  }

  static void _updatePOB() {
    pobNotifier.value = staticDoors.values.fold(0, (sum, count) => sum + count);
  }

  static String readDoor(String message) {
    return message.split('through').lastOrNull?.trim() ?? '';
  }

  static String convertDoors(String door) {
    if (door == gallagherDoorOffice) return officeDoor;
    if (door == gallagherDoorServerOffice) return serverOfficeDoor;
    if (door == gallagherDoorCCR) return ccrDoor;
    if (door == gallagherDoorInORF || door == gallagherDoorOutORF) {
      return orfDoor;
    }
    if (door == gallagherDoorServerORF) return serverORFDoor;
    if (door == gallagherDoorCRO) return croDoor;
    if (door == gallagherDoorPortal) return portalDoor;
    return door;
  }

  static List<CardZonaModel> getPOBPerDoor(List<EventCardholder> dataEvent) {
    processEntry(dataEvent);
    return staticDoors.entries
        .map((entry) => CardZonaModel(
              title: entry.key,
              value: '${entry.value}',
              color: (entry.key == officeDoor || entry.key == orfDoor)
                  ? yellowZone
                  : redZone,
            ))
        .toList();
  }

  static List<CardholderModel> getCardholderOnZoneReport(
      String zone, List<EventCardholder> dataEvent) {
    final List<CardholderModel> result = [];
    final cardholderOnZone = pobOnZoneNotifier.value.firstWhere(
      (zoneData) => zoneData.zone == zone,
      orElse: () => FTItemIDOnZone(zone: zone, ftItemId: []),
    );

    final List<String> cNumList =
        cardholderOnZone.ftItemId.map((e) => e.toString()).toList();
    
    for (var event in dataEvent) {
      final cnum = event.cardholderModel?.ftItemId;
      if (cnum != null && cNumList.contains(cnum.toString())) {
        if (!result.any((e) => e.ftItemId == cnum)) {
          result.add(event.cardholderModel!);
        }
      }
    }

    return result;
  }

  static void exporttoCsv(List<CardholderJson> cardholder) async {
    String? checkLastZone(String cNum) => lastKnownZone[int.parse(cNum)];

    final Map<String, String> cardNumberMap = {
      for (var ch in cardholder)
        '${ch.firstName?.toLowerCase()}|${ch.company?.toLowerCase()}':
            ch.cardNumber ?? '',
    };

    final List<List<String>> rows = [
      ['cardNumber', 'firstName', 'department', 'company', 'lastZone'],
      ...pobEOR.map((e) {
        final key = '${e.firstName?.toLowerCase()}|${e.company?.toLowerCase()}';
        final matchedCardNumber = cardNumberMap[key] ?? '';
        return [
          matchedCardNumber,
          e.firstName ?? '',
          e.departement ?? '',
          e.company ?? '',
          checkLastZone(e.ftItemId.toString()) ?? ''
        ];
      }),
    ];

    final String csvData = const ListToCsvConverter().convert(rows);
    final fileName =
        'eor-${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}.csv';

    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
  }
}



// class POBTracker {
//   // Constants
//   static const int entryEvent = 20001;
//   static const int exitEvent = 20003;

//   static final Map<String, int> staticDoors = {
//     officeDoor: 0,
//     serverOfficeDoor: 0,
//     croDoor: 0,
//     orfDoor: 0,
//     ccrDoor: 0,
//     serverORFDoor: 0,
//     portalDoor: 0,
//   };

//   static final ValueNotifier<List<FTItemIDOnZone>> pobOnZoneNotifier =
//       ValueNotifier<List<FTItemIDOnZone>>(
//     staticDoors.keys
//         .map((doorName) => FTItemIDOnZone(zone: doorName, ftItemId: []))
//         .toList(),
//   );

//   static final Map<String, EventCardholder> latestByCNumber = {};
//   static final ValueNotifier<int> pobNotifier = ValueNotifier<int>(0);
//   static List<CardholderModel> pobEOR = [];
//   static final lastKnownZone = <String, String>{};

//   static void processEntry(List<EventCardholder> dataEvent) {
//     if (dataEvent.isEmpty) return;

//     _resetData();

//     final sortedEvents = _getSortedLatestEvents(dataEvent);

//     for (final event in sortedEvents) {
//       final cnum = event.cardholderModel?.cardNumber;
//       if (cnum == null) continue;
//       final door = readDoor(event.message ?? '');
//       final zone = convertDoors(door);

//       if (event.eventType == entryEvent) {
//         if (lastKnownZone[cnum] != zone) {
//     lastKnownZone[cnum] = zone;
//   }
//         lastKnownZone[cnum] = zone;
//         pobEOR.add(event.cardholderModel!);
//       } else if (event.eventType == exitEvent) {
//         if (zone == officeDoor || zone == orfDoor) {
//           lastKnownZone.remove(cnum);
//           pobEOR.removeWhere((item) => item.cardNumber == cnum);
//         } else if (zone == croDoor || zone == serverOfficeDoor) {
//           lastKnownZone[cnum] = officeDoor;
//         } else if (zone == ccrDoor || zone == serverORFDoor) {
//           lastKnownZone[cnum] = orfDoor;
//         }
//       }
//     }

//     final currentList = List<FTItemIDOnZone>.from(pobOnZoneNotifier.value);

//     for (var item in currentList) {
//       item.ftItemId.clear();
//     }

//     lastKnownZone.forEach((cnum, zone) {
//       if (staticDoors.containsKey(zone)) {
//         staticDoors[zone] = (staticDoors[zone]! + 1);

//         final zoneData = currentList.firstWhere(
//           (element) => element.zone == zone,
//           orElse: () => FTItemIDOnZone(zone: zone, ftItemId: []),
//         );

//         if (!zoneData.ftItemId.contains(cnum)) {
//           zoneData.ftItemId.add(int.parse(cnum));
//         }
//       }
//     });

//     pobOnZoneNotifier.value = currentList;
//     _updatePOB();
//   }

//   static List<EventCardholder> _getSortedLatestEvents(
//       List<EventCardholder> dataEvent) {
//     final sorted = List<EventCardholder>.from(dataEvent)
//       ..sort((a, b) {
//         final aTime = _parseDateTime(a.occurrenceTime);
//         final bTime = _parseDateTime(b.occurrenceTime);
//         return bTime.compareTo(aTime);
//       });

//     latestByCNumber.clear();
//     for (final event in sorted) {
//       final cnum = event.cardholderModel?.cardNumber;
//       if (cnum != null && !latestByCNumber.containsKey(cnum)) {
//         latestByCNumber[cnum] = event;
//       }
//     }
//     return latestByCNumber.values.toList();
//   }

//   static DateTime _parseDateTime(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty) {
//       return DateTime.fromMillisecondsSinceEpoch(0);
//     }
//     final cleaned = dateStr.replaceAll(' ', '');
//     return DateTime.tryParse(cleaned) ?? DateTime.fromMillisecondsSinceEpoch(0);
//   }

//   static void _resetData() {
//     staticDoors.updateAll((key, value) => 0);
//     latestByCNumber.clear();
//     pobNotifier.value = 0;
//     pobEOR.clear();

//     pobOnZoneNotifier.value = staticDoors.keys
//         .map((doorName) => FTItemIDOnZone(zone: doorName, ftItemId: []))
//         .toList();
//   }

//   static void _updatePOB() {
//     pobNotifier.value = staticDoors.values.fold(0, (sum, count) => sum + count);
//   }

//   static List<CardZonaModel> getPOBPerDoor(List<EventCardholder> dataEvent) {
//     processEntry(dataEvent);
//     return staticDoors.entries
//         .map((entry) => CardZonaModel(
//               title: entry.key,
//               value: '${entry.value}',
//               color: (entry.key == officeDoor || entry.key == orfDoor)
//                   ? yellowZone
//                   : redZone,
//             ))
//         .toList();
//   }

  // static String readDoor(String message) {
  //   return message.split('through').lastOrNull?.trim() ?? '';
  // }

  // static String convertDoors(String door) {
  //   if (door == gallagherDoorOffice) return officeDoor;
  //   if (door == gallagherDoorServerOffice) return serverOfficeDoor;
  //   if (door == gallagherDoorCCR) return ccrDoor;
  //   if (door == gallagherDoorInORF || door == gallagherDoorOutORF) {
  //     return orfDoor;
  //   }
  //   if (door == gallagherDoorServerORF) return serverORFDoor;
  //   if (door == gallagherDoorCRO) return croDoor;
  //   if (door == gallagherDoorPortal) return portalDoor;
  //   return door;
  // }

//   static List<CardholderModel> getCardholderOnZoneReport(
//       String zone, List<EventCardholder> dataEvent) {
//     final List<CardholderModel> result = [];
//     final cardholderOnZone = pobOnZoneNotifier.value.firstWhere(
//       (zoneData) => zoneData.zone == zone,
//       orElse: () => FTItemIDOnZone(zone: zone, ftItemId: []),
//     );

//     final List<String> cNumList = cardholderOnZone.ftItemId.map((e)=> e.toString()).toList();

//     for (var event in dataEvent) {
//       final cnum = event.cardholderModel?.cardNumber;
//       if (cnum != null && cNumList.contains(cnum)) {
//         // Cek dulu apakah sudah ada di result
//         if (!result.any((e) => e.cardNumber == cnum)) {
//           result.add(event.cardholderModel!);
//         }
//       }
//     }

//     return result;
//   }

//   static void exporttoCsv(List<CardholderJson> cardholder) async {
//     String? checkLastZone(String cNum) => lastKnownZone[cNum];

//     final Map<String, String> cardNumberMap = {
//       for (var ch in cardholder)
//         '${ch.firstName?.toLowerCase()}|${ch.company?.toLowerCase()}':
//             ch.cardNumber ?? '',
//     };

//     final List<List<String>> rows = [
//       ['cardNumber', 'firstName', 'department', 'company', 'lastZone'],
//       ...pobEOR.map((e) {
//         final key = '${e.firstName?.toLowerCase()}|${e.company?.toLowerCase()}';
//         final matchedCardNumber = cardNumberMap[key] ?? '';

//         return [
//           matchedCardNumber,
//           e.firstName ?? '',
//           e.departement ?? '',
//           e.company ?? '',
//           checkLastZone(matchedCardNumber) ?? ''
//         ];
//       }),
//     ];

//     final String csvData = const ListToCsvConverter().convert(rows);
//     final fileName =
//         'eor-${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}.csv';

//     final bytes = utf8.encode(csvData);
//     final blob = html.Blob([bytes], 'text/csv');
//     final url = html.Url.createObjectUrlFromBlob(blob);

//     html.AnchorElement(href: url)
//       ..setAttribute("download", fileName)
//       ..click();

//     // html.Url.revokeObjectUrl(url);
//     // String? checkLastZone(String cNum) => lastKnownZone[cNum];
//     // final List<List<String>> rows = [
//     //   ['cardNumber', 'firsName', 'department', 'company', 'lastZone'],
//     //   ...pobEOR.map((e) => [
//     //         e.cardNumber ?? '',
//     //         e.firstName ?? '',
//     //         e.departement ?? '',
//     //         e.company ?? '',
//     //         checkLastZone(e.cardNumber ?? '') ?? ''
//     //       ]),
//     // ];

//     // final String csvData = const ListToCsvConverter().convert(rows);

//     // final fileName =
//     //     'eor-${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}.csv';

//     // final bytes = utf8.encode(csvData);
//     // final blob = html.Blob([bytes], 'text/csv');
//     // final url = html.Url.createObjectUrlFromBlob(blob);

//     // html.AnchorElement(href: url)
//     //   ..setAttribute("download", fileName)
//     //   ..click();

//     // html.Url.revokeObjectUrl(url);
//   }
// }



// class POBTracker {
//   // Constants
//   static const int entryEvent = 20001;
//   static const int exitEvent = 20003;

//   static final Map<String, int> staticDoors = {
//     officeDoor: 0,
//     serverOfficeDoor: 0,
//     croDoor: 0,
//     orfDoor: 0,
//     ccrDoor: 0,
//     serverORFDoor: 0,
//     portalDoor: 0,
//   };

//   static final ValueNotifier<List<FTItemIDOnZone>> pobOnZoneNotifier =
//       ValueNotifier<List<FTItemIDOnZone>>(staticDoors.keys
//           .map((doorName) => FTItemIDOnZone(zone: doorName, cardNumber: []))
//           .toList());
//   static final Map<String, EventCardholder> latestByCNumber = {};
//   static final ValueNotifier<int> pobNotifier = ValueNotifier<int>(0);

//   static void processEntry(List<EventCardholder> dataEvent) {
//     if (dataEvent.isEmpty) return;

//     _resetData();

//     final sortedEvents = _getSortedLatestEvents(dataEvent);
//     final lastKnownZone = <String, String>{};

//     for (final event in sortedEvents) {
//       final cnum = event.cardholderModel!.cardNumber!;
//       final door = readDoor(event.message!);
//       final zone = convertDoors(door);

//       if (event.eventType == entryEvent) {
//         lastKnownZone[cnum] = zone;
//       } else if (event.eventType == exitEvent) {
//         if (zone == officeDoor || zone == orfDoor) {
//           // keluar dari kantor, tidak dihitung
//           lastKnownZone.remove(cnum);
//         } else if (zone == croDoor || zone == serverOfficeDoor) {
//           // masuk kantor dari luar
//           lastKnownZone[cnum] = officeDoor;
//         } else if (zone == ccrDoor || zone == serverORFDoor) {
//           lastKnownZone[cnum] = orfDoor;
//         }
//       }
//     }

//     lastKnownZone.forEach((cnum, zone) {
//       if (staticDoors.containsKey(zone)) {
//         staticDoors[zone] = staticDoors[zone]! + 1;
//         final currentList =
//             List<FTItemIDOnZone>.from(pobOnZoneNotifier.value);

//         for (var item in currentList) {
//           if (item.zone == zone) {
//             // Tambahkan cnum ke pintu yang cocok (kalau belum ada)
//             if (!item.cardNumber.contains(cnum)) {
//               item.cardNumber.add(cnum);
//             }
//           } else {
//             // Hapus cnum dari pintu lain
//             item.cardNumber.remove(cnum);
//           }
//         }

//         pobOnZoneNotifier.value = currentList;
//       }
//     });

//     _updatePOB();
//   }

//   static List<EventCardholder> _getSortedLatestEvents(
//       List<EventCardholder> dataEvent) {
//     final sorted = List<EventCardholder>.from(dataEvent)
//       ..sort((a, b) {
//         final aTime = DateTime.parse(a.occurrenceTime!.replaceAll(' ', ''));
//         final bTime = DateTime.parse(b.occurrenceTime!.replaceAll(' ', ''));
//         return bTime.compareTo(aTime);
//       });

//     // Only keep the latest event per cardNumber
//     latestByCNumber.clear();
//     for (final event in sorted) {
//       final cnum = event.cardholderModel!.cardNumber;
//       if (cnum != null && !latestByCNumber.containsKey(cnum)) {
//         latestByCNumber[cnum] = event;
//       }
//     }
//     return latestByCNumber.values.toList();
//   }

//   static void _resetData() {
//     staticDoors.updateAll((key, value) => 0);
//     latestByCNumber.clear();
//     pobNotifier.value = 0;
//   }

//   static void _updatePOB() {
//     pobNotifier.value = staticDoors.values.fold(0, (sum, count) => sum + count);
//   }

//   static List<CardZonaModel> getPOBPerDoor(List<EventCardholder> dataEvent) {
//     processEntry(dataEvent);
//     return staticDoors.entries
//         .map((entry) => CardZonaModel(
//               title: entry.key,
//               value: '${entry.value}',
//               color: (entry.key == officeDoor || entry.key == orfDoor)
//                   ? yellowZone
//                   : redZone,
//             ))
//         .toList();
//   }

//   static String readDoor(String message) {
//     return message.split('through').last.trim();
//   }

//   static String convertDoors(String door) {
//     if (door == gallagherDoorOffice) return officeDoor;
//     if (door == gallagherDoorServerOffice) return serverOfficeDoor;
//     if (door == gallagherDoorCCR) return ccrDoor;
//     if (door == gallagherDoorInORF || door == gallagherDoorOutORF)
//       return orfDoor;
//     if (door == gallagherDoorServerORF) return serverORFDoor;
//     if (door == gallagherDoorCRO) return croDoor;
//     if (door == gallagherDoorPortal) return portalDoor;
//     return door;
//   }
// }



// class POBTracker {
//   static Map<String, int> staticDoors = {
//     officeDoor: 0,
//     serverOfficeDoor: 0,
//     croDoor: 0,
//     orfDoor: 0,
//     ccrDoor: 0,
//     serverORFDoor: 0,
//     portalDoor: 0,
//   };

//   static Map<String, EventCardholder> latestByCNumber = {};
//   //static int pob = 0;

//   static ValueNotifier<int> pobNotifier = ValueNotifier<int>(0);


//   static void processEntry(List<EventCardholder> dataEvent) {
//     Map<String, String> lastKnownZone = {};

//     // Reset data
//     staticDoors.updateAll((key, value) => 0);
//     latestByCNumber.clear();
//     pobNotifier.value = 0;

//     if (dataEvent.isNotEmpty) {
//       dataEvent.sort((a, b) {
//         final aTime = DateTime.parse(a.occurrenceTime!.replaceAll(' ', ''));
//         final bTime = DateTime.parse(b.occurrenceTime!.replaceAll(' ', ''));
//         return bTime.compareTo(aTime); // Urut dari terbaru ke terlama
//       });

//       for (var event in dataEvent) {
//         final cnum = event.cardNumber;
//         if (!latestByCNumber.containsKey(cnum)) {
//           latestByCNumber[cnum!] = event;
//         }
//       }

//       for (var event in latestByCNumber.values) {
//         final door = readDoor(event.message!);
//         final zone = convertDoors(door);

//         if (event.eventType == 20001) {
//           // pob++;
//           lastKnownZone[event.cardNumber!] = zone;
//         } else if (event.eventType == 20003) {
//           lastKnownZone.remove(event.cardNumber!);
//           //final lastZone = lastKnownZone[event.cardNumber!];

//           if (zone == officeDoor || zone == orfDoor) {
//             // Keluar dari kantor, tidak dihitung lagi
//             lastKnownZone.remove(event.cardNumber!);
//           } else {
//             // Dari luar kantor, dianggap masuk ke kantor
//             if (zone == croDoor || zone == serverOfficeDoor) {
//               lastKnownZone[event.cardNumber!] = officeDoor;
//             } else if (zone == ccrDoor ||
//                 zone == serverORFDoor ||
//                 zone == portalDoor) {
//               lastKnownZone[event.cardNumber!] = orfDoor;
//             }
//           }
//         }
//       }
//       lastKnownZone.forEach((cnum, zone) {
//         if (staticDoors.containsKey(zone)) {
//           staticDoors[zone] = staticDoors[zone]! + 1;
//         }
//       });
//       pobNotifier.value = countPOB();
//     }
//   }

//   static int countPOB() =>
//       staticDoors.values.fold(0, (sum, count) => sum + count);

//   static List<CardZonaModel> getPOBPerDoor(List<EventCardholder> dataEvent) {
//     processEntry(dataEvent);
//     return staticDoors.entries
//         .map((entry) => CardZonaModel(
//               title: entry.key,
//               value: '${entry.value}',
//               color: entry.key == officeDoor || entry.key == orfDoor
//                   ? yellowZone
//                   : redZone,
//             ))
//         .toList();
//   }

//   static String readDoor(String message) {
//     return message.split('through').last.trim();
//   }

//   static String convertDoors(String door) {
//     final msgDoor = readDoor(door);
//     if (msgDoor == gallagherDoorOffice) {
//       return officeDoor;
//     } else if (msgDoor == gallagherDoorServerOffice) {
//       return serverOfficeDoor;
//     } else if (msgDoor == gallagherDoorCCR) {
//       return ccrDoor;
//     } else if (msgDoor == gallagherDoorInORF ||
//         msgDoor == gallagherDoorOutORF) {
//       return orfDoor;
//     } else if (msgDoor == gallagherDoorServerORF) {
//       return serverORFDoor;
//     } else if (msgDoor == gallagherDoorCRO) {
//       return croDoor;
//     } else if (msgDoor == gallagherDoorPortal) {
//       return portalDoor;
//     }
//     return msgDoor;
//   }
// }
