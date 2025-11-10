class ReplantingForm {
  final String? id;
  final String plantingForm;
  final String farmName;
  final String lotNumber;
  final String variety;
  final DateTime replantingDate;
  final int additionalSeedsUsed;
  final String? reason;
  final double? affectedArea;
  final String? observations;
  final String producerId;

  ReplantingForm({
    this.id,
    required this.plantingForm,
    required this.farmName,
    required this.lotNumber,
    required this.variety,
    required this.replantingDate,
    required this.additionalSeedsUsed,
    this.reason,
    this.affectedArea,
    this.observations,
    required this.producerId,
  });

  factory ReplantingForm.fromJson(Map<String, dynamic> json) {
    return ReplantingForm(
      id: json['_id'],
      plantingForm: json['plantingForm'],
      farmName: json['farmName'],
      lotNumber: json['lotNumber'],
      variety: json['variety'] is String ? json['variety'] : json['variety']['_id'],
      replantingDate: DateTime.parse(json['replantingDate']),
      additionalSeedsUsed: json['additionalSeedsUsed'],
      reason: json['reason'],
      affectedArea: json['affectedArea']?.toDouble(),
      observations: json['observations'],
      producerId: json['producerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'plantingForm': plantingForm,
      'farmName': farmName,
      'lotNumber': lotNumber,
      'variety': variety,
      'replantingDate': replantingDate.toIso8601String(),
      'additionalSeedsUsed': additionalSeedsUsed,
      'reason': reason,
      'affectedArea': affectedArea,
      'observations': observations,
      'producerId': producerId,
    };
  }
}
