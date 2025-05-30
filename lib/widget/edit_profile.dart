import 'dart:convert';

import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/model/cardholder_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    required this.cardholder,
    super.key,
  });
  final CardholderJson cardholder;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final cardNumberController = TextEditingController();
  final nameController = TextEditingController();
  final companyController = TextEditingController();

  Future<void> submitData(String ftItemId, String cardNumber) async {
    try {
      final url = Uri.parse('$urlServer/saveprofile');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'FTItemID': ftItemId.toString(),
          'CardNumber': cardNumber,
        }),
      );

      if (response.statusCode == 200) {
        showSnackbarResponse(message: 'Update Success', color: Colors.green);
        goPop(true);
      } else {
        showSnackbarResponse(
            message: 'Failed: ${response.statusCode} - ${response.body}',
            color: Colors.red);
      }
    } catch (e) {
      showSnackbarResponse(message: 'contact developer', color: Colors.red);
    }
  }

  void goPop(bool isSuccess) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, isSuccess);
  }

  void showSnackbarResponse({required String message, required Color color}) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );

  @override
  void initState() {
    nameController.text = widget.cardholder.firstName ?? '';
    companyController.text = widget.cardholder.company ?? '';
    cardNumberController.text = widget.cardholder.cardNumber ?? '';
    super.initState();
  }

  @override
  Widget build(context) {
    return Material(
      elevation: 10,
      shadowColor: Colors.blue,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: IconButton(
                icon: Icon(Icons.close, size: 30, color: Colors.red),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            textfield(
                controller: nameController, label: 'Name', isReadOnly: true),
            textfield(
                controller: companyController,
                label: 'Company',
                isReadOnly: true),
            textfield(controller: cardNumberController, label: 'Card Number'),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, right: 30),
              child: ElevatedButton(
                onPressed: () => submitData(
                    widget.cardholder.ftItemId!, cardNumberController.text),
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textfield(
          {required TextEditingController controller,
          required String label,
          bool isReadOnly = false}) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: label,
          ),
          readOnly: isReadOnly,
        ),
      );
}
