import 'package:flutter/material.dart';

import 'banned_countries_list.dart';
import 'countries_list.dart';

class CountryListScreen extends StatefulWidget {
  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  TextEditingController searchController = TextEditingController();
  Map<String, List<String>> groupedCountries = {};
  List<String> filteredCountries = [];

  @override
  void initState() {
    super.initState();

    for (var country in allCountries) {
      final initial = country[0].toUpperCase();
      if (!groupedCountries.containsKey(initial)) {
        groupedCountries[initial] = [];
      }
      groupedCountries[initial]?.add(country);
    }

    filteredCountries = allCountries;
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCountries = allCountries;
      } else {
        filteredCountries = allCountries
            .where((country) =>
                country.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showBannedPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Country Not Allowed'),
          content: Text('Sorry, this country is banned.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Country'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for a country...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filterCountries,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                final country = filteredCountries[index];
                final isBanned = bannedCountries.contains(country);

                String? divider;
                if (index == 0 ||
                    country[0] != filteredCountries[index - 1][0]) {
                  divider = country[0];
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (divider != null)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: Colors.grey.shade200,
                        child: Text(
                          divider,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ListTile(
                      title: Text(
                        country,
                        style: TextStyle(
                          color: isBanned
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onTap: () {
                        if (isBanned) {
                          _showBannedPopup(context);
                        } else {
                          Navigator.pop(context, country);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
