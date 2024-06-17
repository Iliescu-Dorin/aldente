import 'package:aldente/models/specialty.dart';

class Doctor {
  final String? id;
  final String? collectionId;
  final String? collectionName;
  final DateTime? created;
  final DateTime? updated;
  final String? doctorId;
  final List<String>? specialtyIds;
  final String? licenseNumber;
  final int? yearsOfExperience;
  final double? rating;
  List<Specialty>? specialties;

  Doctor({
    this.id,
    this.collectionId,
    this.collectionName,
    this.created,
    this.updated,
    this.doctorId,
    this.specialtyIds,
    this.licenseNumber,
    this.yearsOfExperience,
    this.rating,
    this.specialties,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      doctorId: json['doctor_id'],
      specialtyIds: List<String>.from(json['specialty_id'] ?? []),
      licenseNumber: json['license_number'],
      yearsOfExperience: json['years_of_exp'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collectionId': collectionId,
      'collectionName': collectionName,
      'created': created?.toIso8601String(),
      'updated': updated?.toIso8601String(),
      'doctor_id': doctorId,
      'specialty_id': specialtyIds,
      'license_number': licenseNumber,
      'years_of_exp': yearsOfExperience,
      'rating': rating,
    };
  }
}