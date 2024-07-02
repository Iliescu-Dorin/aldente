import 'package:aldente/pages/x_rays_camera/explore_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ExplorePageController controller = Get.put(ExplorePageController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: Obx(() => _buildBody(controller)),
    );
  }

  Widget _buildBody(ExplorePageController controller) {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.currentLocation.value == null) {
      return const Center(child: Text('Location not available'));
    }
    return _buildMap(controller);
  }

  Widget _buildMap(ExplorePageController controller) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: controller.currentLocation.value!,
        initialZoom: 13.0,
      ),
      children: [
        _buildTileLayer(),
        _buildMarkerLayer(controller),
      ],
    );
  }

  Widget _buildTileLayer() {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    );
  }

  Widget _buildMarkerLayer(ExplorePageController controller) {
    return MarkerLayer(
      markers: [
        _buildCurrentLocationMarker(controller),
        ...controller.markers,
      ],
    );
  }

  Marker _buildCurrentLocationMarker(ExplorePageController controller) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: controller.currentLocation.value!,
      child: const Icon(
        Icons.location_on,
        color: Colors.blue,
        size: 40.0,
      ),
    );
  }
}