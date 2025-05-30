import 'package:flutter/material.dart';

const cardBackgroundColor = Color(0xFF21222D);
const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFFFFFFFF);
const backgroundColor = Color(0xFF15131C);
const selectionColor = Color(0xFF88B2AC);

const orfColor = Color(0xFFF7C5CA);
const officeColor = Color(0xFFC6F7D0);
const orfServerColor = Color(0xFFB8E6FF);
const officeServerColor = Color(0xFFFFC9A6);
const orfCCRColor = Color(0xFFF5DEB3);
const officeCROColor = Color(0xFFE67E73);
const portalColor = Color(0xFFD973E6);

const redZone = Color(0xFFB43D35);
const yellowZone = Color(0xFFFFD700);
const greenZone = Color(0xFF27AE60);

const urlServer = 'http://10.68.20.7:3000';
const imageUrl = '$urlServer/images';

//const String secretKey = String.fromEnvironment('SECRET_KEY');

// const String buserpras =
//     '5b0b4186ac7f893a5d4c666f6b07b714780ec59e20b9a9f447b0ebf96ab745ac';
// const String busermane =
//     'eb89d60ac30d999e6a2692ccba15bff40e6f28bd4165f96c4e3ad0f7a1b5acb9';

const titleStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white);
const bodyStyle = TextStyle(color: Colors.white);

const defaultPadding = 20.0;

// doors messages from gallagher
const gallagherDoorOffice = 'LOBBY  - New Building.';
const gallagherDoorServerOffice = 'Server Room - New Building LT 2.';
const gallagherDoorCCR = 'CCR Room - Old Building.';
const gallagherDoorInORF = 'Barrier Gate IN- Old Building.';
const gallagherDoorOutORF = 'Barrier Gate OUT - Old Building.';
const gallagherDoorServerORF = 'Server Room - Old Building.';
const gallagherDoorCRO = 'CRO Room - New Building.';
const gallagherDoorPortal = 'Door Portal.';

//static doors NEWS
const officeDoor = 'Office';
const orfDoor = 'ORF Area';
const ccrDoor = 'CCR';
const croDoor = 'CRO Office';
const serverOfficeDoor = 'Server Office';
const serverORFDoor = 'Server ORF';
const portalDoor = 'Door Portal';

//chart max total POB
const maxYChart = 250;

const Map<int, String> leftLabel = {
  0: '0',
  50: '50',
  100: '100',
  150: '150',
  200: '200',
  maxYChart: '$maxYChart'
};

