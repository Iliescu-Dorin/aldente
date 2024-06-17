class Clinic {
  final String id;
  final String collectionId;
  final String collectionName;
  final DateTime created;
  final DateTime updated;
  final String clinicId;
  final String address;
  final String phoneNumber;
  final List<String> doctors;

  Clinic({
    required this.id,
    required this.collectionId,
    required this.collectionName,
    required this.created,
    required this.updated,
    required this.clinicId,
    required this.address,
    required this.phoneNumber,
    required this.doctors,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      clinicId: json['clinic_id'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      doctors: List<String>.from(json['doctors']),
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
      'address': address,
      'phone_number': phoneNumber,
      'doctors': doctors,
    };
  }
}