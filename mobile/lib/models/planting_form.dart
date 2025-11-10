import 'variety.dart';

class PlantingForm {
  final String id;
  final String farmName;
  final String lotNumber;
  final String? valveNumber;
  final Variety variety;
  final double area;
  final DateTime plantingDate;
  final DateTime? expectedHarvestDate;
  final DateTime? confirmedHarvestDate;
  final String status;
  final String? observations;
  final String producerId;

  PlantingForm({
    required this.id,
    required this.farmName,
    required this.lotNumber,
    this.valveNumber,
    required this.variety,
    required this.area,
    required this.plantingDate,
    this.expectedHarvestDate,
    this.confirmedHarvestDate,
    required this.status,
    this.observations,
    required this.producerId,
  });

  factory PlantingForm.fromJson(Map<String, dynamic> json) {
    return PlantingForm(
      id: json['_id'],
      farmName: json['farmName'],
      lotNumber: json['lotNumber'],
      valveNumber: json['valveNumber'],
      variety: Variety.fromJson(json['variety']),
      area: json['area'].toDouble(),
      plantingDate: DateTime.parse(json['plantingDate']),
      expectedHarvestDate: json['expectedHarvestDate'] != null
          ? DateTime.parse(json['expectedHarvestDate'])
          : null,
      confirmedHarvestDate: json['confirmedHarvestDate'] != null
          ? DateTime.parse(json['confirmedHarvestDate'])
          : null,
      status: json['status'],
      observations: json['observations'],
      producerId: json['producerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'farmName': farmName,
      'lotNumber': lotNumber,
      'valveNumber': valveNumber,
      'variety': variety.toJson(),
      'area': area,
      'plantingDate': plantingDate.toIso8601String(),
      'expectedHarvestDate': expectedHarvestDate?.toIso8601String(),
      'confirmedHarvestDate': confirmedHarvestDate?.toIso8601String(),
      'status': status,
      'observations': observations,
      'producerId': producerId,
    };
  }
}
