import 'package:dashboard_pob/model/cardholder_model.dart';

class FTItemIDOnZone {
  const FTItemIDOnZone({
    required this.zone,
    required this.ftItemId,
  });
  final String zone;
  final List<int> ftItemId;
}

class CardholderOnZone {
  const CardholderOnZone({
    required this.zone,
    required this.cardHolder,
  });
  final String zone;
  final List<CardholderModel> cardHolder;
}
