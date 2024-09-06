import 'package:flutter/material.dart';
import 'package:nav_app/models/city_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 


class City {
  final String name;
  final LatLng coordinates;

  City({
    required this.name,
    required this.coordinates,
  });
}

class CityDropdown extends StatelessWidget {
  final List<City> cities;
  final City? selectedCity;
  final ValueChanged<City?> onCitySelected;

  const CityDropdown({
    Key? key,
    required this.cities,
    required this.selectedCity,
    required this.onCitySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButton<City>(
        hint: const Text('Select a city'),
        value: selectedCity,
        isExpanded: true,
        items: cities.map((City city) {
          return DropdownMenuItem<City>(
            value: city,
            child: Text(city.name),
          );
        }).toList(),
        onChanged: onCitySelected,
      ),
    );
  }
}
