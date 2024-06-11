import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMarker extends StatelessWidget {
  final LatLng point;
  final String imagePath;
  final VoidCallback onTap;

  const CustomMarker({
    super.key,
    required this.point,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 50.0,
          ),
          Positioned(
            top: 5.0,
            left: 5.0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  imagePath,
                  width: 30.0,
                  height: 30.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  void _showMarkerDetails(
      BuildContext context, String title, String details, String imagePath) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: imagePath,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        child: Image.asset(
                          imagePath,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        details,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 120.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: 100.0,
                              margin: const EdgeInsets.only(right: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Item ${index + 1}'),
                                  const SizedBox(height: 18.0),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                          horizontal: 16.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: const Text(
                                          'Sample Badge',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Services Offered:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Column(
                        children: [
                          _buildServiceItem('Service 1'),
                          _buildServiceItem('Service 2'),
                          _buildServiceItem('Service 3'),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the clinic page
                            // Add your navigation logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            'Go to the clinic page',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceItem(String service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              service,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(42.3601, -71.0589), // Boston coordinates
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              // Marker 1
              Marker(
                width: 80.0,
                height: 80.0,
                point: const LatLng(42.3601, -71.0589),
                child: CustomMarker(
                  point: const LatLng(42.3601, -71.0589),
                  imagePath: 'assets/icons/dental_surgeon.png',
                  onTap: () {
                    _showMarkerDetails(
                      context,
                      'Dental Surgeon',
                      'Details about the dental surgeon.',
                      'assets/icons/dental_surgeon.png',
                    );
                  },
                ),
              ),
              // Marker 2
              Marker(
                width: 80.0,
                height: 80.0,
                point: const LatLng(42.3631, -71.0983),
                child: CustomMarker(
                  point: const LatLng(42.3631, -71.0983),
                  imagePath: 'assets/icons/heart_surgeon.png',
                  onTap: () {
                    _showMarkerDetails(
                      context,
                      'Heart Surgeon',
                      'Details about the heart surgeon.',
                      'assets/icons/heart_surgeon.png',
                    );
                  },
                ),
              ),
              // Add more markers for points of interest
            ],
          ),
        ],
      ),
    );
  }
}
