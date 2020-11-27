import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/i18n.dart' as location_picker;
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class GetLocation2 extends StatefulWidget {
  @override
  _GetLocation2State createState() => _GetLocation2State();
}

class _GetLocation2State extends State<GetLocation2> {
  LocationResult _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData.dark(),
      title: 'location picker',
      localizationsDelegates: const [
        location_picker.S.delegate,
        //S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', ''),
        Locale('ph', ''),
        Locale('uk', ''),
        Locale('jp', ''),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const AutoSizeText('location picker'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    LocationResult result = await showLocationPicker(
                      context,
                      "AIzaSyAmiJ65xZEpp2SVHj56w-ih7qrSXUi4e3U",
                      initialCenter: LatLng(14.3429, 120.8503),
                      automaticallyAnimateToCurrentLocation: true,
                      mapStylePath: 'assets/mapStyle.json',
                      myLocationButtonEnabled: true,
                      layersButtonEnabled: true, resultCardAlignment: Alignment.bottomCenter,
                    );
                    print("result = $result");
                    setState(() => _pickedLocation = result);
                  },
                  child: AutoSizeText('Pick location'),
                ),
                AutoSizeText(_pickedLocation.toString()),
              ],
            ),
          );
        }),
      ),
    );
  }
}

