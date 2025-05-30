// import 'package:dashboard_pob/const/constanta.dart';
// import 'package:dashboard_pob/model/card_zone.dart';
// import 'package:dashboard_pob/model/event_cardholder.dart';

// class CountingCardholder {
//   static CountingModel countingZones(List<EventCardholder> dataEvent) {
//     final Map<String, int> inCounts = {
//       'ORF Area': 0,
//       'Office': 0,
//       'CCR ORF': 0,
//       'Server ORF': 0,
//       'Server Office': 0,
//       'CRO': 0,
//       'Total': 0,
//     };
//     final Map<String, int> outCounts = {
//       'ORF Area': 0,
//       'Office': 0,
//       'CCR ORF': 0,
//       'Server ORF': 0,
//       'Server Office': 0,
//       'CRO': 0,
//       'Total': 0,
//     };

//     for (var data in dataEvent) {
//       final door = readDoor(data.message!);
//       final isEntry = data.eventType == 20001;
//       final isExit = data.eventType == 20003;
//       if (isEntry) {
//         if (door == doorOffice) {
//           inCounts['Office'] = (inCounts['Office'] ?? 0) + 1;
//         } else if (door == doorServerORF) {
//           inCounts['Server ORF'] = (inCounts['Server ORF'] ?? 0) + 1;
//         } else if (door == doorServerOffice) {
//           inCounts['Server Office'] = (inCounts['Server Office'] ?? 0) + 1;
//         } else if (door == doorInORF) {
//           inCounts['ORF Area'] = (inCounts['ORF Area'] ?? 0) + 1;
//         } else if (door == doorCCR) {
//           inCounts['CCR ORF'] = (inCounts['CCR ORF'] ?? 0) + 1;
//         } else if (door == doorCRO) {
//           inCounts['CRO'] = (inCounts['CRO'] ?? 0) + 1;
//         }
//         inCounts['Total'] = (inCounts['Total'] ?? 0) + 1;
//       } else if (isExit) {
//         if (door == doorOffice) {
//           outCounts['Office'] = (outCounts['Office'] ?? 0) + 1;
//         } else if (door == doorServerORF) {
//           outCounts['Server ORF'] = (outCounts['Server ORF'] ?? 0) + 1;
//         } else if (door == doorServerOffice) {
//           outCounts['Server Office'] = (outCounts['Server Office'] ?? 0) + 1;
//         } else if (door == doorOutORF) {
//           outCounts['ORF Area'] = (outCounts['ORF Area'] ?? 0) + 1;
//         } else if (door == doorCCR) {
//           outCounts['CCR ORF'] = (outCounts['CCR ORF'] ?? 0) + 1;
//         } else if (door == doorCRO) {
//           outCounts['CRO'] = (outCounts['CRO'] ?? 0) + 1;
//         }
//         outCounts['Total'] = (outCounts['Total'] ?? 0) + 1;
//       }
//     }

//     return CountingModel(
//       total: (inCounts['Total'] ?? 0) - (outCounts['Total'] ?? 0),
//       cardZonaModels: [
//         CardZonaModel(
//             title: 'Office Area',
//             value: '${(inCounts['Office'] ?? 0) - (outCounts['Office'] ?? 0)}',
//             color: yellowZone),
//         CardZonaModel(
//             title: 'ORF Area',
//             value:
//                 '${(inCounts['ORF Area'] ?? 0) - (outCounts['ORF Area'] ?? 0)}',
//             color: yellowZone),
//         CardZonaModel(
//             title: 'CCR',
//             value: '${(inCounts['CCR'] ?? 0) - (outCounts['CCR'] ?? 0)}',
//             color: redZone),
//         CardZonaModel(
//             title: 'Server ORF',
//             value:
//                 '${(inCounts['Server ORF'] ?? 0) - (outCounts['Server ORF'] ?? 0)}',
//             color: redZone),
//         CardZonaModel(
//             title: 'Server Office',
//             value:
//                 '${(inCounts['Server Office'] ?? 0) - (outCounts['Server Office'] ?? 0)}',
//             color: redZone),
//         CardZonaModel(
//             title: 'CRO',
//             value: '${(inCounts['CRO'] ?? 0) - (outCounts['CRO'] ?? 0)}',
//             color: redZone),

//         // CardZonaModel(
//         //     title: 'Office Area',
//         //     value: '${(inCounts['Office'] ?? 0) - (outCounts['Office'] ?? 0)}',
//         //     color: yellowZone),
//         // CardZonaModel(
//         //     title: 'ORF Area',
//         //     value: '${(inCounts['ORF'] ?? 0) - (outCounts['ORF'] ?? 0)}',
//         //     color: yellowZone),
//         // CardZonaModel(
//         //     title: 'CCR',
//         //     value: '${(inCounts['CCR'] ?? 0) - (outCounts['CCR'] ?? 0)}',
//         //     color: redZone),
//         // CardZonaModel(
//         //     title: 'Server ORF',
//         //     value:
//         //         '${(inCounts['Server ORF'] ?? 0) - (outCounts['Server ORF'] ?? 0)}',
//         //     color: redZone),
//         // CardZonaModel(
//         //     title: 'Server Office',
//         //     value:
//         //         '${(inCounts['Server Office'] ?? 0) - (outCounts['Server Office'] ?? 0)}',
//         //     color: redZone),
//         // CardZonaModel(
//         //     title: 'CRO',
//         //     value: '${(inCounts['CRO'] ?? 0) - (outCounts['CRO'] ?? 0)}',
//         //     color: redZone),
//       ],
//     );
//   }

//   static String readDoor(String message) {
//     return message.split('through').last.trim();
//   }
// }

// class CountingModel {
//   final int total;
//   final List<CardZonaModel> cardZonaModels;
//   CountingModel({required this.total, required this.cardZonaModels});
// }
