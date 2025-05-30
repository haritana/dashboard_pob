import 'dart:convert';
import 'dart:developer';

import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/data/pob_tracker.dart';
import 'package:dashboard_pob/model/cardholder_model.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';
import 'package:dashboard_pob/widget/edit_profile.dart';
import 'package:dashboard_pob/widget/upload_photo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final searchController = TextEditingController();
  List<CardholderJson> cardholder = [];
  List<CardholderJson> filteredCardholder = [];

  final fileNameController = TextEditingController();

  Future<void> getProfile() async {
    try {
      final url = Uri.parse('$urlServer/getcardholder');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          final res = cardholderJsonFromJson(response.body);
          cardholder = res;
          filteredCardholder = res;
        });
      } else {
        log('Failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  showDialogSubmit(CardholderJson data) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => EditProfilePage(
          cardholder: data,
        ),
      );

  void getMusterpoint() async {
    try {
      final urlMusterpoint = Uri.parse('$urlServer/getevent');
      final response = await http.get(urlMusterpoint);
      if (response.statusCode == 200) {
        setState(() {
          final dataconvert = jsonDecode(response.body);
          final data = listEventCardholder(dataconvert);
          POBTracker.processEntry(data);
          POBTracker.exporttoCsv(cardholder);
        });
      } else {
        log('Failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('error $e');
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Admin Page',
          style: bodyStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              getProfile();
            },
            icon: IconButton(
              icon: Icon(
                Icons.download,
                color: Colors.white,
              ),
              onPressed: () {
                // if (cardholder.isEmpty) {
                //   print('kosong');
                // } else {
                //   POBTracker.exporttoCsv(cardholder);
                // }
                getMusterpoint();
              },
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                  height: 500,
                  child: UploadPhotoPage(
                    fileNameController: fileNameController,
                  )),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search user...',
                  hintStyle: bodyStyle,
                  labelStyle: bodyStyle,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                style: bodyStyle,
                onChanged: (value) {
                  setState(() {
                    filteredCardholder = cardholder
                        .where((item) => item.firstName!
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCardholder.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text(
                        '${index + 1}',
                        style: bodyStyle,
                      ),
                      title: Text(
                        filteredCardholder[index].firstName ?? '',
                        style: bodyStyle,
                      ),
                      subtitle: Text(
                        '${filteredCardholder[index].company} - ${filteredCardholder[index].cardNumber!.isNotEmpty ? '[${filteredCardholder[index].cardNumber}]' : ''}',
                        style: bodyStyle,
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus(); // LEPAS FOKUS
                          await Future.delayed(Duration(milliseconds: 50));
                          final result =
                              await showDialogSubmit(filteredCardholder[index]);

                          if (result == true) {
                            getProfile();
                          }
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      onLongPress: () {
                        setState(() {
                          fileNameController.text =
                              filteredCardholder[index].ftItemId.toString();
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
