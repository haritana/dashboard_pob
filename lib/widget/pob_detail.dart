import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/widget/custom_card.dart';
import 'package:flutter/material.dart';

class SummaryDetails extends StatelessWidget {
  const SummaryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: const Color(0xFF2F353E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDetails('ORF', color: orfColor),
          buildDetails('Office', color: officeColor),
          buildDetails('CCR', color: orfCCRColor),
          buildDetails('Server ORF', color: orfServerColor),
          buildDetails('Server Office', color: officeServerColor),
          buildDetails('CRO', color: officeCROColor),
          buildDetails('Portal', color: portalColor),
        ],
      ),
    );
  }

  Widget buildDetails(String value, {Color? color}) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 10,
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
