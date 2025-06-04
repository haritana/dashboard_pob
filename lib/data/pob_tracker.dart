import 'dart:convert';
import 'dart:developer';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;
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

  static String? checkLastZone(String cNum) => lastKnownZone[int.parse(cNum)];

  static void exportToTwoCsvFiles() async {
    try {
      final urlPekerja = Uri.parse('$urlServer/getcardholder');
      final pekerjaResponse = await http.get(urlPekerja);

      final urlMusterpoint = Uri.parse('$urlServer/getevent');
      final eventResponse = await http.get(urlMusterpoint);

      if (pekerjaResponse.statusCode != 200 ||
          eventResponse.statusCode != 200) {
        throw Exception("Failed to fetch data");
      }
      final dataconvert = jsonDecode(eventResponse.body);
      final eventData = listEventCardholder(dataconvert);
      final pekerjaData = cardholderJsonFromJson(pekerjaResponse.body);
      processEntry(eventData);

      final Map<String, String> cardNumberMap = {
        for (var ch in pekerjaData)
          '${ch.firstName?.toLowerCase()}|${ch.company?.toLowerCase()}':
              ch.cardNumber ?? '',
      };

      //  ==== CSV 1: EOR ====
      final List<List<String>> cardholderRows = [
        ['cardNumber', 'firstName', 'department', 'company', 'lastZone'],
        ...pobEOR.map((e) {
          final key =
              '${e.firstName?.toLowerCase()}|${e.company?.toLowerCase()}';
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
      final String csvCardholder =
          const ListToCsvConverter().convert(cardholderRows);
      final String fileNameCardholder = 'EOR-${_todayString()}.csv';
      _downloadCsv(csvCardholder, fileNameCardholder);

      // ==== CSV 2: Pekerja ====
      final List<List<String>> pekerjaRows = [
        ['cardNumber', 'firstName', 'department', 'company'],
        ...pekerjaData.map((e) => [
              e.cardNumber ?? '',
              e.firstName ?? '',
              e.department ?? '',
              e.company ?? '',
            ]),
      ];
      final String csvPekerja = const ListToCsvConverter().convert(pekerjaRows);
      final String fileNamePekerja = 'pekerja-${_todayString()}.csv';
      _downloadCsv(csvPekerja, fileNamePekerja);
    } catch (e) {
      log('error $e');
    }
  }

  static void _downloadCsv(String csvData, String fileName) {
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  static String _todayString() {
    final now = DateTime.now();
    return '${now.day}-${now.month}-${now.year}';
  }
}
