import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:permission_handler/permission_handler.dart';
class map extends StatefulWidget {

  @override
  _mapState createState() => _mapState();
}

class _mapState extends State<map> {

  MapController controller = new MapController();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 5);
  LatLng _location = LatLng(10.758902, 106.676216);
  Geolocator geolocator = Geolocator();
  StreamSubscription<Position> stream ;
  //_updateLocation();
  Position userLocation;
  List<List<double>> polylineCoordinates = [
    [10.758902, 106.676216],
    [10.723834, 106.703592],
    [10.795834, 106.705592],
    [10.799834, 106.709592]
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     stream = geolocator.getPositionStream(locationOptions).listen(
        (Position position) {
            setState(() {
              print('move');
              _location = LatLng(position.latitude,position.longitude);
            });
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    Geolocator _geolocator;
    //checkPermission();
    Widget Fluttermap(){
      return new FlutterMap(
        mapController: controller,
        options: new MapOptions(
          center: _location,
          zoom: 14.0,
          plugins: [
            TappablePolylineMapPlugin(),
          ],
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c']
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 10.0,
                height: 10.0,
                anchorPos: AnchorPos.align(AnchorAlign.center),
                point:  _location,
                builder: (ctx) =>
                new Container(
                  child: new Icon(Icons.gps_fixed,color: Colors.red,),
                ),
              ),
            ],
          ),
          TappablePolylineLayerOptions(
            // Will only render visible polylines, increasing performance
              polylineCulling: true,
              pointerDistanceTolerance: 20,
              polylines: [
                TaggedPolyline(
                  tag: 'My Polyline',
                  // An optional tag to distinguish polylines in callback
                  points:  _getpolyline(),
                  color: Colors.red,
                  strokeWidth: 5.0,
                ),
              ],
              onTap: (TaggedPolyline polyline) => print(polyline.tag))
        ],
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Fluttermap(),
        Positioned(
            top: 10,
            right: 10,
            child: ClipOval(
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: SizedBox(width: 35, height: 35, child: Icon(Icons.my_location)),
                  onTap: () async{
                    _getLocation().then((value) {
                      setState(() {
                        _location = LatLng(value.latitude,value.longitude);
                      });
                    });
                  },
                ),
              ),
            )
        ),
      ],
    );
  }
  List<LatLng> _getpolyline(){
    return polylineCoordinates.map((e) => LatLng(e[0], e[1])).toList();
  }
  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      controller.move(new LatLng(currentLocation.latitude,currentLocation.longitude), 0);
    } catch (e) {
      currentLocation = null;

    }
    return currentLocation;
  }
   /*_updateLocation() async {
    geolocator
        .getPositionStream(LocationOptions(
        accuracy: LocationAccuracy.best, timeInterval: 1000))
        .listen((position) {
      // Do something here
    });
  }*/
}
