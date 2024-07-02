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
        avatarUrl: clinicData['avatarUrl'] ,
        onTap: () => _showMarkerDetails(clinicData),
      ),
    );
  }

  void _showMarkerDetails(Map<String, dynamic> clinicData) {
    Get.bottomSheet(
      _buildMarkerDetailsSheet(clinicData),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildMarkerDetailsSheet(Map<String, dynamic> clinicData) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clinicData['name'] ?? 'Unknown Clinic',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Email: ${clinicData['email'] ?? 'N/A'}'),
          const SizedBox(height: 8),
          Text('Phone: ${clinicData['phone_number']}'),
          const SizedBox(height: 8),
          Text('Doctors: ${clinicData['doctors'].length}'),
          const SizedBox(height: 8),
          Text(clinicData['details']),
           const SizedBox(height: 8),
          Text(clinicData['avatarUrl']),
          const SizedBox(height: 16),
          _buildClinicDetailsButton(clinicData['id']),
        ],
      ),
    );
  }

  Widget _buildClinicDetailsButton(String clinicId) {
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

  // void showMarkerDetails(
  //   BuildContext context,
  //   String title,
  //   String details,
  //   String imagePath,
  // ) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) => _buildMarkerDetailsSheet(
  //       context,
  //       title,
  //       details,
  //       imagePath,
  //     ),
  //   );
  // }

  // Widget _buildMarkerDetailsSheet(
  //   BuildContext context,
  //   String title,
  //   String details,
  //   String imagePath,
  // ) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.7,
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
  //     ),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           _buildImageHeader(context, imagePath),
  //           Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 _buildTitleAndRating(title),
  //                 const SizedBox(height: 16.0),
  //                 Text(details, style: const TextStyle(fontSize: 18.0)),
  //                 const SizedBox(height: 16.0),
  //                 _buildHorizontalItemList(),
  //                 const SizedBox(height: 16.0),
  //                 _buildServicesOffered(),
  //                 const SizedBox(height: 16.0),
  //                 _buildClinicPageButton(),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

