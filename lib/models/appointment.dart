class Appointment {
  final String id;
  final String collectionId;
  final String collectionName;
  final DateTime created;
  final DateTime updated;
  final String doctorId;
  final String clinicId;
  final String serviceId;
  final String clientId;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  Appointment({
    required this.id,
    required this.collectionId,
    required this.collectionName,
    required this.created,
    required this.updated,
    required this.doctorId,
    required this.clinicId,
    required this.serviceId,
    required this.clientId,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      doctorId: json['doctor_id'],
      clinicId: json['clinic_id'],
      serviceId: json['service_id'],
      clientId: json['client_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collectionId': collectionId,
      'collectionName': collectionName,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'doctor_id': doctorId,
      'clinic_id': clinicId,
      'service_id': serviceId,
      'client_id': clientId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'status': status,
    };
  }
}