import 'package:dashboard_pob/core/tts.dart';
import 'package:flutter/material.dart';

import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/data/pob_tracker.dart';
import 'package:dashboard_pob/model/cardholder_model.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';
import 'package:dashboard_pob/widget/activity.dart';
import 'package:dashboard_pob/widget/dialog_member.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MaterialApp(
    home: SimulasiPOB(),
  ));
}

class SimulasiPOB extends StatefulWidget {
  const SimulasiPOB({super.key});

  @override
  State<SimulasiPOB> createState() => _SimulasiPOBState();
}

class _SimulasiPOBState extends State<SimulasiPOB> {
  int pobT = 0;

  List<EventCardholder> listEvent = [];

  List<UserTap> users = [
    UserTap(
        fTItemID: 11,
        firstName: 'Rooby Haritana',
        cardNumber: '1231',
        company: 'company',
        image: 'image',
        workSchedule: 'workSchedule',
        departement: 'ICT'),
    UserTap(
        fTItemID: 12,
        firstName: 'Cristiano Ronaldo',
        cardNumber: '1232',
        company: 'company',
        image: 'image',
        workSchedule: 'workSchedule',
        departement: 'Production'),
    UserTap(
        fTItemID: 13,
        firstName: 'Ahmad Ahsanul Faalih',
        cardNumber: '1233',
        company: 'company',
        image: 'image',
        workSchedule: 'workSchedule',
        departement: 'HSE'),
    UserTap(
        fTItemID: 14,
        firstName: 'Kim Jong Un',
        cardNumber: '1234',
        company: 'company',
        image: 'image',
        workSchedule: 'workSchedule',
        departement: 'GA'),
    UserTap(
        fTItemID: 15,
        firstName: 'Adeeva Afsheen Inara',
        cardNumber: '1235',
        company: 'company',
        image: 'image',
        workSchedule: 'workSchedule',
        departement: 'departement'),
    UserTap(
        fTItemID: 16,
        firstName: 'Abdullah bin abu bakar as sidiq',
        cardNumber: '1236',
        company: 'company',
        image: 'image',
        workSchedule: 'workSchedule',
        departement: 'departement'),
  ];

  void checkAndSpeak(EventCardholder cardholder) async {
    final name = cardholder.cardholderModel?.firstName;
    final userId = cardholder.cardholderModel?.ftItemId?.toString();
    final message = POBTracker.readDoor(cardholder.message ?? '');
    final door = POBTracker.convertDoors(message);

    bool doorAllowed = door == 'Office' || door == 'ORF Area';

    if (cardholder.eventType == 20001 &&
        name != null &&
        userId != null &&
        doorAllowed) {
      SpeakCardholder.handleSpeak(userId, name, door);
    }

    // // final name = cardholder.cardholderModel?.firstName;
    // // final message = POBTracker.readDoor(cardholder.message!);
    // // final door = POBTracker.convertDoors(message);
    // // bool doorOnSpeak = door == 'Office' || door == 'ORF Area';

    // // if (cardholder.eventType == 20001 &&
    // //     // doorOnSpeak &&
    // //     name != null &&
    // //     name != _lastSpokenName) {
    // //   _lastSpokenName = name;

    // //   SpeakCardholder.speak(name, door);
    // // }
    // final model = cardholder.cardholderModel;
    // final userId = model?.ftItemId.toString();
    // final name = model?.firstName;
    // final message = POBTracker.readDoor(cardholder.message!);
    // final door = POBTracker.convertDoors(message);

    // print(SpeakCardholder.isSpeaking);
    // print(SpeakCardholder.lastUserId);

    // if (cardholder.eventType == 20001 &&
    //     name != null &&
    //     userId != null &&
    //     (userId != SpeakCardholder.lastUserId || !SpeakCardholder.isSpeaking)) {
    //   SpeakCardholder.speak(userId, name, door);
    //   // if (SpeakCardholder.isSpeaking) {
    //   //   SpeakCardholder.stop().then((_) {
    //   //     SpeakCardholder.speak(userId, name, door);
    //   //   });
    //   // } else {}
    // }
  }

  Future<List<UserTap>> getData() async => users;

  @override
  void initState() {
    SpeakCardholder.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POB Simulasi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: POBTracker.pobNotifier,
              builder: (context, pob, child) {
                return Text(
                  'TOTAL POB: $pob',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                );
              },
            ),
            ActivityDetailsCard(
              zonaCount: POBTracker.getPOBPerDoor(listEvent),
              onTap: (val) {
                List<CardholderModel> member = [];
                member = POBTracker.getCardholderOnZoneReport(val, listEvent);
                if (member.isNotEmpty) {
                  openDialogMember(
                      zone: val, cardholder: member, context: context);
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(child: userTapping()),
                Expanded(child: cardEventUsers()),

                // Expanded(
                //   child: ValueListenableBuilder<List<CardholderOnZone>>(
                //     valueListenable: POBTracker.pobOnZoneNotifier,
                //     builder: (context, pob, child) {
                //       return ListView.builder(
                //         shrinkWrap: true,
                //         itemCount: pob.length,
                //         itemBuilder: (ctx, index) => ListTile(
                //           leading: Text(pob[index].zone),
                //           title: Text(pob[index].cardNumber.toString()),
                //         ),
                //       );
                //     },
                //   ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cardEventUsers() {
    final sorted = List<EventCardholder>.from(listEvent)
      ..sort((a, b) {
        final aTime = DateTime.parse(a.occurrenceTime!.replaceAll(' ', ''));
        final bTime = DateTime.parse(b.occurrenceTime!.replaceAll(' ', ''));
        return bTime.compareTo(aTime);
      });
    final limited = sorted.take(5).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('USER Live'),
        SingleChildScrollView(
          child: Column(
            children: List.generate(
                limited.length,
                (index) => ListTile(
                      leading: Icon(
                        Icons.door_back_door,
                        color: sorted[index].eventType == 20001
                            ? greenZone
                            : Colors.red,
                      ),
                      title: Text(sorted[index].cardholderModel!.firstName!),
                      subtitle:
                          Text(sorted[index].cardholderModel!.departement!),
                      trailing: Text(sorted[index].message!),
                    )),
          ),
        )
      ],
    );
  }

  Widget cardholderEventLive() => Card(
        child: ListTile(
          title: Text(users.last.firstName ?? ''),
        ),
      );
  Widget userTapping() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Users Table'),
          users.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      users.length,
                      (index) => ListTile(
                        leading: Text('${index + 1}'),
                        title: Text(users[index].firstName!),
                        subtitle:
                            Text('CardNumber: ${users[index].cardNumber}'),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 40,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.door_back_door,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      _openDialog(
                                          context: context,
                                          action: 20001,
                                          user: users[index]);
                                    },
                                  )),
                              SizedBox(
                                  width: 40,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.door_back_door,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _openDialog(
                                          context: context,
                                          action: 20003,
                                          user: users[index]);
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const Text('Tidak ada Data')
        ],
      );

  Future<void> _openDialog({
    required BuildContext context,
    required int action,
    required UserTap user,
  }) async {
    final selectedValue = await showDialog<String>(
      context: context,
      builder: (context) {
        String selectedValue = officeDoor;

        return AlertDialog(
          title: const Text('Select an Option'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedValue,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      }
                    },
                    items: <String>[
                      officeDoor,
                      orfDoor,
                      serverORFDoor,
                      serverOfficeDoor,
                      ccrDoor,
                      croDoor,
                      portalDoor
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(selectedValue);
                    },
                    child: const Text('Submit'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    if (selectedValue != null) {
      checkAndSpeak(EventCardholder(
          eventId: 'eventId',
          cardholderModel: CardholderModel(
              ftItemId: user.fTItemID,
              firstName: user.firstName,
              cardNumber: user.cardNumber,
              relationCode: 1,
              company: user.company,
              image: user.image,
              workSchedule: user.workSchedule,
              departement: user.departement),
          message: selectedValue,
          occurrenceTime: 'occurrenceTime',
          eventType: action,
          arrivalTime: 'arrivalTime'));
      final now = DateTime.now().toUtc();
      final formatted = now.toIso8601String();
      (context as Element).markNeedsBuild();
      listEvent.add(EventCardholder(
        eventId: '${listEvent.length + 1}',
        cardholderModel: CardholderModel(
            ftItemId: user.fTItemID,
            firstName: user.firstName,
            cardNumber: user.cardNumber,
            relationCode: 0,
            company: user.company,
            image: user.image,
            workSchedule: user.workSchedule,
            departement: user.departement),
        // ftItemId: user.fTItemID,
        // firstName: user.firstName,
        // cardNumber: user.cardNumber,
        message: selectedValue,
        occurrenceTime: formatted,
        eventType: action,
        arrivalTime: formatted,
        // relationCode: 0,
        // company: user.company,
        // image: user.image,
        // workSchedule: user.workSchedule,
        // departement: user.departement,
      ));
    }
  }
}

class UserTap {
  const UserTap({
    required this.fTItemID,
    required this.firstName,
    required this.cardNumber,
    required this.company,
    required this.image,
    required this.workSchedule,
    required this.departement,
  });

  final int? fTItemID;
  final String? firstName;
  final String? cardNumber;
  final String? company;
  final String? image;
  final String? workSchedule;
  final String? departement;
}
