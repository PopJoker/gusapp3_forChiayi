import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerPage extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapPickerPage({super.key, this.initialLat, this.initialLng});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? _pickedLocation;
  LatLng? _currentLocation;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    LatLng? deviceLocation;

    if (widget.initialLat != null && widget.initialLng != null) {
      deviceLocation = LatLng(widget.initialLat!, widget.initialLng!);
    } else {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('請開啟定位服務');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('定位權限被拒絕');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print('定位權限永久被拒絕');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      deviceLocation = LatLng(position.latitude, position.longitude);
    }

    setState(() {
      _currentLocation = deviceLocation;
      _pickedLocation ??= deviceLocation;
    });

    // 地圖移動到目前位置
    if (deviceLocation != null) {
      _mapController.move(deviceLocation, 16);
    }
  }

  void _onTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _pickedLocation = point;
    });
  }

  void _goToCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 16);
      setState(() {
        _pickedLocation = _currentLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('選擇位置'),
        actions: [
          TextButton(
            onPressed: _pickedLocation == null
                ? null
                : () {
                    Navigator.pop(context, _pickedLocation);
                  },
            child: const Text(
              '確定',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          onTap: _onTap,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          if (_pickedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _pickedLocation!,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
