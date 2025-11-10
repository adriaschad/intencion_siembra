class BrixReading {
  final double value;
  final String? location;

  BrixReading({
    required this.value,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'location': location,
    };
  }

  factory BrixReading.fromJson(Map<String, dynamic> json) {
    return BrixReading(
      value: json['value'].toDouble(),
      location: json['location'],
    );
  }
}

class SamplingForm {
  final String? id;
  final String plantingForm;
  final String farmName;
  final String lotNumber;
  final String? valveNumber;
  final String variety;
  final DateTime samplingDate;
  final List<BrixReading> brixReadings;
  final double? averageBrix;
  final String? observations;
  final List<String> photos;
  final String producerId;

  SamplingForm({
    this.id,
    required this.plantingForm,
    required this.farmName,
    required this.lotNumber,
    this.valveNumber,
    required this.variety,
    required this.samplingDate,
    required this.brixReadings,
    this.averageBrix,
    this.observations,
    this.photos = const [],
    required this.producerId,
  });

  factory SamplingForm.fromJson(Map<String, dynamic> json) {
    return SamplingForm(
      id: json['_id'],
      plantingForm: json['plantingForm'],
      farmName: json['farmName'],
      lotNumber: json['lotNumber'],
      valveNumber: json['valveNumber'],
      variety: json['variety'] is String ? json['variety'] : json['variety']['_id'],
      samplingDate: DateTime.parse(json['samplingDate']),
      brixReadings: (json['brixReadings'] as List)
          .map((r) => BrixReading.fromJson(r))
          .toList(),
      averageBrix: json['averageBrix']?.toDouble(),
      observations: json['observations'],
      photos: (json['photos'] as List<dynamic>).map((p) => p.toString()).toList(),
      producerId: json['producerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'plantingForm': plantingForm,
      'farmName': farmName,
      'lotNumber': lotNumber,
      'valveNumber': valveNumber,
      'variety': variety,
      'samplingDate': samplingDate.toIso8601String(),
      'brixReadings': brixReadings.map((r) => r.toJson()).toList(),
      'averageBrix': averageBrix,
      'observations': observations,
      'photos': photos,
      'producerId': producerId,
    };
  }
}
