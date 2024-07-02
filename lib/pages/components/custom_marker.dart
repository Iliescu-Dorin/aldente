import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CustomMarker extends StatelessWidget {
  final LatLng point;
  final String avatarUrl;
  final VoidCallback onTap;

  const CustomMarker({
    super.key,
    required this.point,
    required this.avatarUrl,
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
            child: ClipOval(
              child: Image.network(
                avatarUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
