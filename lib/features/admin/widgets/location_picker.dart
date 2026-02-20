import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class LocationPicker extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  final Function(double lat, double lng) onLocationChanged;

  const LocationPicker({
    super.key,
    required this.initialLat,
    required this.initialLng,
    required this.onLocationChanged,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController _controller;
  late LatLng _currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(widget.initialLat, widget.initialLng);
    _updateMarker(_currentPosition);
  }

  void _updateMarker(LatLng position) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected-location'),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) {
            _onMapTap(newPosition);
          },
        ),
      };
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _currentPosition = position;
      _updateMarker(position);
    });
    widget.onLocationChanged(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Location',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppTheme.spacingS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 15,
                  ),
                  markers: _markers,
                  onMapCreated: (controller) => _controller = controller,
                  onTap: _onMapTap,
                  myLocationButtonEnabled: false,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoom_in',
                        onPressed: () {
                          _controller.animateCamera(CameraUpdate.zoomIn());
                        },
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.add, color: AppColors.textMedium),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        onPressed: () {
                          _controller.animateCamera(CameraUpdate.zoomOut());
                        },
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.remove, color: AppColors.textMedium),
                      ),
                    ],
                  ),
                ),
                Positioned(
                   bottom: 10,
                   left: 10,
                   right: 10,
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                     decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.9),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: Text(
                       'Lat: ${_currentPosition.latitude.toStringAsFixed(5)}, Lng: ${_currentPosition.longitude.toStringAsFixed(5)}',
                       style: const TextStyle(fontSize: 12),
                       textAlign: TextAlign.center,
                     ),
                   ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
