import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/model/card_zone.dart';
import 'package:dashboard_pob/widget/custom_card.dart';
import 'package:flutter/material.dart';

class ActivityDetailsCard extends StatelessWidget {
  const ActivityDetailsCard({
    required this.zonaCount,
    required this.onTap,
    super.key,
  });

  final List<CardZonaModel> zonaCount;
  final Function(String) onTap;
  @override
  Widget build(BuildContext context) {
    return zonaCount.isEmpty
        ? Container()
        : GridView.builder(
            itemCount: zonaCount.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 15,
              mainAxisSpacing: 12.0,
            ),
            itemBuilder: (context, index) => CustomCard(
              color: zonaCount[index].color,
              child: InkWell(
                onTap: () => onTap(zonaCount[index].title),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 4),
                      child: Text(
                        zonaCount[index].value,
                        style: TextStyle(
                          fontSize: 50,
                          color: zonaCount[index].color == redZone
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              offset: const Offset(1.0, 1.0),
                              blurRadius: 1.0,
                              color: zonaCount[index].color == redZone
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            Shadow(
                              offset: const Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: zonaCount[index].color == redZone
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      zonaCount[index].title,
                      style: TextStyle(
                        fontSize: 18,
                        color: zonaCount[index].color == redZone
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
