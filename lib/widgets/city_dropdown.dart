import 'package:flutter/material.dart';
import 'package:nav_app/models/city_model.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.0),
          border: Border.all(color: Colors.blueAccent, width: 1.0),
        ),
        height: 50,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<City>(
            value: selectedCity,
            hint: const Text(
              'Select a city',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            isExpanded: true,
            icon: Icon(Icons.where_to_vote_rounded, color: Colors.blueAccent),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: Colors.white,
            items: cities.map((City city) {
              return DropdownMenuItem<City>(
                value: city,
                child: Text(
                  city.name,
                  style: const TextStyle(
                    fontSize: 16, 
                    color: Colors.blueAccent,
                  ),
                ),
              );
            }).toList(),
            onChanged: (City? newCity) {
              onCitySelected(newCity);
            },
          ),
        ),
      ),
    );
  }
}
