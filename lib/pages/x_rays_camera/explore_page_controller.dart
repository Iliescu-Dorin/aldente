import 'package:aldente/pages/components/custom_marker.dart';
import 'package:aldente/services/pocketbase/pocketbase_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ExplorePageController extends GetxController {
  final isLoading = false.obs;
  final markers = <Marker>[].obs;
  final currentLocation = Rxn<LatLng>();

  @override
  void onInit() {
    super.onInit();
    _initializeExplorer();
  }

  Future<void> _initializeExplorer() async {
    await getCurrentLocation();
    await loadMarkers();
  }

  Future<void> getCurrentLocation() async {
    try {
      final permission = await _checkAndRequestLocationPermission();
      if (permission == LocationPermission.denied) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      Get.log("Error getting location: $e");
    }
  }

  Future<LocationPermission> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  Future<void> loadMarkers() async {
    isLoading.value = true;
    try {
      final markerData = await PocketbaseService.to.getMarkers();
      markers.value = markerData.map(_createMarker).toList();
    } catch (e) {
      Get.log('Error loading markers: $e');
      _showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Marker _createMarker(Map<String, dynamic> clinicData) {
    final coordinates = clinicData['coordinates'] as Map<String, dynamic>;
    final point = LatLng(coordinates['latitude'], coordinates['longitude']);

    return Marker(
      width: 80.0,
      height: 80.0,
      point: point,
      child: CustomMarker(
        point: point,
        avatarUrl: clinicData['avatarUrl'],
        onTap: () => _showMarkerDetails(clinicData),
      ),
    );
  }

  void _showMarkerDetails(Map<String, dynamic> clinicData) {
    Get.bottomSheet(
      _buildMarkerDetailsSheet(clinicData),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildMarkerDetailsSheet(Map<String, dynamic> clinicData) {
    return Container(
      height: Get.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageHeader(clinicData['avatarUrl']),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndRating(clinicData['name']),
                  const SizedBox(height: 16.0),
                  Text(clinicData['details'],
                      style: const TextStyle(fontSize: 18.0)),
                  const SizedBox(height: 16.0),
                  _buildHorizontalItemList(),
                  const SizedBox(height: 16.0),
                  _buildServicesOffered(),
                  const SizedBox(height: 16.0),
                  _buildClinicPageButton(clinicData['id']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(String imagePath) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitleAndRating(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            Text('4.5', style: TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );
  }

Widget _buildHorizontalItemList() {
  final List<Map<String, String>> doctors = [
    {'name': 'Dr. Emma Smith', 'specialty': 'Orthodontist'},
    {'name': 'Dr. James Brown', 'specialty': 'Periodontist'},
    {'name': 'Dr. Olivia Johnson', 'specialty': 'Endodontist'},
    {'name': 'Dr. William Lee', 'specialty': 'Oral Surgeon'},
    {'name': 'Dr. Sophia Garcia', 'specialty': 'Prosthodontist'},
    {'name': 'Dr. Michael Chen', 'specialty': 'Pediatric Dentist'},
    {'name': 'Dr. Emily Taylor', 'specialty': 'General Dentist'},
  ];

  return SizedBox(
    height: 220,  // Increased height
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return Container(
          width: 140,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),  // Added vertical margin
          padding: const EdgeInsets.all(8),  // Added padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/generic_doctor.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doctors[index]['name']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),  // Added space between name and specialty
              Text(
                doctors[index]['specialty']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    ),
  );
}

  Widget _buildServicesOffered() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Services Offered',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(label: Text('General Checkup')),
            Chip(label: Text('Teeth Cleaning')),
            Chip(label: Text('Teeth Whitening')),
            Chip(label: Text('Root Canal')),
            Chip(label: Text('Dental Implants')),
            Chip(label: Text('Orthodontics')),
            Chip(label: Text('Oral Surgery')),
          ],
        ),
      ],
    );
  }

  Widget _buildClinicPageButton(String clinicId) {
    return ElevatedButton(
      onPressed: () => _navigateToClinicDetails(clinicId),
      child: const Text('View Clinic Details'),
    );
  }

  void _navigateToClinicDetails(String clinicId) {
    Get.back();
    Get.toNamed('/clinic/$clinicId');
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
