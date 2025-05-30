import 'dart:developer';

import 'package:dashboard_pob/const/constanta.dart';
import 'package:dashboard_pob/core/tts.dart';
import 'package:dashboard_pob/data/pob_tracker.dart';
import 'package:dashboard_pob/model/event_cardholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    required this.cardholder,
    super.key,
  });

  final EventCardholder cardholder;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late final FlutterTts flutterTts;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    SpeakCardholder.init();
  }

  @override
  void didUpdateWidget(covariant ProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkAndSpeak(widget.cardholder);
  }

  void printAvailableVoices() async {
    final voices = await flutterTts.getVoices;
    for (var voice in voices) {
      log('Voice: ${voice['name']}, Locale: ${voice['locale']}');
    }
  }

  void _checkAndSpeak(EventCardholder cardholder) {
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
  }

  @override
  Widget build(BuildContext context) {
    final cardholder = widget.cardholder;
    final data = cardholder.cardholderModel!;
    final doors = POBTracker.readDoor(cardholder.message!);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final dateTimeUtc = DateTime.parse(cardholder.occurrenceTime!).toUtc();
    final dateTimeWib = dateTimeUtc.add(const Duration(hours: 7));
    final dateFormat = DateFormat('HH:mm:ss').format(dateTimeWib);

    const inColor = Color(0xFF4CAF50);
    const outColor = Color(0xffff6f61);

    return SizedBox(
      width: width * 0.3,
      height: height / 2.5,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: cardholder.eventType! == 20001 ? inColor : outColor,
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding:
                const EdgeInsets.only(top: 90, left: 20, right: 20, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  data.firstName ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 30),
                InfoRow(
                  icon: Icons.apartment,
                  iconColor: Colors.white,
                  label: data.departement ?? '',
                  labelColor: Colors.white,
                ),
                const SizedBox(height: 12),
                InfoRow(
                  icon: Icons.business,
                  iconColor: Colors.white,
                  label: data.company ?? '',
                  labelColor: Colors.white,
                ),
                const SizedBox(height: 12),
                InfoRow(
                  icon: Icons.timer_rounded,
                  iconColor: Colors.white,
                  label: dateFormat,
                  labelColor: Colors.white,
                ),
                const SizedBox(height: 12),
                InfoRow(
                  icon: Icons.meeting_room,
                  iconColor:
                      cardholder.eventType! == 20001 ? inColor : outColor,
                  label: doors,
                  labelColor: Colors.white,
                ),
              ],
            ),
          ),
          Positioned(
            top: -80,
            left: (width * 0.3 - 160) / 2,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: backgroundColor,
              child: ClipOval(
                child: data.image != null && data.image!.isNotEmpty
                    ? Image.network(
                        '$imageUrl/${data.image!}',
                        width: 160,
                        height: 160,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/image/blank.png',
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/image/blank.png',
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;

  const InfoRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: labelColor,
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
