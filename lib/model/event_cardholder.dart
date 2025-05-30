import 'package:dashboard_pob/model/cardholder_model.dart';

List<EventCardholder> listEventCardholder(List<dynamic> respon) =>
    respon.map((x) => EventCardholder.fromJson(x)).toList();

class EventCardholder {
  final String? eventId;
  final CardholderModel? cardholderModel;
  final String? message;
  final String? occurrenceTime;
  final int? eventType;
  final String? arrivalTime;

  EventCardholder({
    required this.eventId,
    required this.cardholderModel,
    required this.message,
    required this.occurrenceTime,
    required this.eventType,
    required this.arrivalTime,
  });

  factory EventCardholder.fromJson(Map<String, dynamic> json) =>
      EventCardholder(
        eventId: json["EventID"] ?? '',
        cardholderModel: CardholderModel(
          ftItemId: json["FTItemID"] ?? 0,
          firstName: json["FirstName"] ?? '',
          cardNumber: json["CardNumber"] ?? '',
          relationCode: json["RelationCode"] ?? '',
          company: json["Company"] ?? '',
          image: json["Image"] ?? '',
          workSchedule: json["WorkSchedule"] ?? '',
          departement: json["Departement"] ?? '',
        ),
        message: json["Message"] ?? '',
        occurrenceTime: json["OccurrenceTime"] ?? '',
        eventType: json["EventType"] ?? 0,
        arrivalTime: json["ArrivalTime"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "EventID": eventId,
        "FTItemID": cardholderModel?.firstName,
        "FirstName": cardholderModel?.firstName,
        "CardNumber": cardholderModel?.cardNumber,
        "Message": message,
        "OccurrenceTime": occurrenceTime,
        "EventType": eventType,
        "ArrivalTime": arrivalTime,
        "RelationCode": cardholderModel?.relationCode,
        "Company": cardholderModel?.company,
        "Image": cardholderModel?.image,
        "WorkSchedule": cardholderModel?.workSchedule,
        "Departement": cardholderModel?.departement,
      };
}
