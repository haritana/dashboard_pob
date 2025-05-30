import 'dart:convert';

class CardholderModel {
  final int? ftItemId;
  final String? firstName;
  final String? cardNumber;
  final int? relationCode;
  final String? company;
  final String? image;
  final String? workSchedule;
  final String? departement;

  const CardholderModel({
    required this.ftItemId,
    required this.firstName,
    required this.cardNumber,
    required this.relationCode,
    required this.company,
    required this.image,
    required this.workSchedule,
    required this.departement,
  });
}

List<CardholderJson> cardholderJsonFromJson(String str) =>
    List<CardholderJson>.from(
        json.decode(str).map((x) => CardholderJson.fromJson(x)));

String cardholderJsonToJson(List<CardholderJson> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CardholderJson {
  String? ftItemId;
  String? cardNumber;
  String? firstName;
  String? department;
  String? company;

  CardholderJson({
    this.ftItemId,
    this.cardNumber,
    this.firstName,
    this.department,
    this.company,
  });

  factory CardholderJson.fromJson(Map<String, dynamic> json) => CardholderJson(
        ftItemId: json["FTItemID"],
        cardNumber: json["CardNumber"],
        firstName: json["FirstName"],
        department: json["Department"],
        company: json["Company"],
      );

  Map<String, dynamic> toJson() => {
        "FTItemID": ftItemId,
        "CardNumber": cardNumber,
        "FirstName": firstName,
        "Department": department,
        "Company": company,
      };
}
