class DoctorService {
  final String id;
  final String collectionId;
  final String collectionName;
  final DateTime created;
  final DateTime updated;
  final String clinicId;
  final String doctorId;
  final String serviceId;
  final int price;

  DoctorService({
    required this.id,
    required this.collectionId,
    required this.collectionName,
    required this.created,
    required this.updated,
    required this.clinicId,
    required this.doctorId,
    required this.serviceId,
    required this.price,
  });

  factory DoctorService.fromJson(Map<String, dynamic> json) {
    return DoctorService(
      id: json['id'],
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      clinicId: json['clinic_id'],
      doctorId: json['doctor_id'],
      serviceId: json['service_id'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collectionId': collectionId,
      'collectionName': collectionName,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'clinic_id': clinicId,
      'doctor_id': doctorId,
      'service_id': serviceId,
      'price': price,
    };
  }
}