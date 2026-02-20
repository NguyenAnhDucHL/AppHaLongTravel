import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class LocationViewer extends StatefulWidget {
  final double lat;
  final double lng;
  final String? address;

  const LocationViewer({
    super.key,
    required this.lat,
    required this.lng,
    this.address,
  });

  @override
  State<LocationViewer> createState() => _LocationViewerState();
}

class _LocationViewerState extends State<LocationViewer> {
  late GoogleMapController _controller;
  late CameraPosition _initialPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(
      target: LatLng(widget.lat, widget.lng),
      zoom: 15,
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('location'),
        position: LatLng(widget.lat, widget.lng),
        infoWindow: widget.address != null ? InfoWindow(title: widget.address!) : InfoWindow.noText,
      ),
    );
  }

  Future<void> _openMap() async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.lng}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (controller) => _controller = controller,
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton.small(
                    onPressed: _openMap,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.directions, color: AppColors.primaryBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.address != null) ...[
           const SizedBox(height: 8),
           Row(
             children: [
               const Icon(Icons.location_on, size: 16, color: AppColors.textLight),
               const SizedBox(width: 4),
               Expanded(
                 child: Text(
                   widget.address!,
                   style: Theme.of(context).textTheme.bodySmall,
                 ),
               ),
             ],
           ),
        ],
      ],
    );
  }
}
