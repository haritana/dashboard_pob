import 'package:dashboard_pob/data/dummydata.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';
import 'package:flutter/material.dart';

class MusterPointPage extends StatefulWidget {
  const MusterPointPage({super.key});

  @override
  State<MusterPointPage> createState() => _MusterPointPageState();
}

class _MusterPointPageState extends State<MusterPointPage> {
  List<EventCardholder> dataEvent = [];

  Future<void> refreshData() async {
    dataEvent = await fakeJason().then((onValue) {
      var res = onValue.where((e) => e.eventType == 20001).toList();
      return res;
    });
    setState(() {});
  }

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POB Muster Point'),
      ),
      body: SingleChildScrollView(
        child: dataEvent.isNotEmpty
            ? Column(
                children: dataEvent
                    .map(
                  (e) => ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(e.cardholderModel!.firstName ?? ''),
                    subtitle: Text(
                        '${e.cardholderModel!.departement} - ${e.cardholderModel!.company}'),
                    trailing: Text(e.message ?? ''),
                  ),
                )
                    .followedBy([
                  ListTile(
                    title: Text('Total POB: ${dataEvent.length} Personla'),
                  )
                ]).toList(),
              )
            : const Text('No Data'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MusterPointPage(),
  ));
}
