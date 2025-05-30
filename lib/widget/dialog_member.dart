import 'package:dashboard_pob/model/cardholder_model.dart';
import 'package:flutter/material.dart';

openDialogMember({
  required BuildContext context,
  required String zone,
  required List<CardholderModel> cardholder,
}) {
  return showDialog(
      context: context,
      builder: (ctx) {
        final screen = MediaQuery.of(context).size;
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Zone $zone'),
              ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.red),
                            foregroundColor: WidgetStatePropertyAll(
                                Colors.white), // Text color
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                          child: const Text('Close'),
                        )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: screen.width - 100,
                height: screen.height - 200,
                child: Card(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        cardholder.isNotEmpty
                            ? Column(
                                children: List.generate(
                                  cardholder.length,
                                  (index) => ListTile(
                                    leading: Text('${index + 1}'),
                                    title: Text(cardholder[index].firstName ?? ''),
                                    subtitle: Text(
                                      '${cardholder[index].company} - ${cardholder[index].departement}',
                                    ),
                                  ),
                                ),
                              )
                            : const Text('Tidak ada Member'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      });
}
