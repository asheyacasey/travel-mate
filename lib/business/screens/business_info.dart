import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_mate/business/screens/business_home.dart';

class BusinessInfoScreen extends StatefulWidget {
  final String? userId;

  const BusinessInfoScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessAddressController =
      TextEditingController();
  List<String> _addressSuggestions = [];
  String? _businessNameError;
  String? _businessAddressError;
  bool _isFormValid = false;

  void saveBusinessInfo() async {
    setState(() {
      _isFormValid = true;
      _businessAddressError = null;
      _businessNameError = null;
    });

    String businessName = _businessNameController.text;
    String businessAddress = _businessAddressController.text;

    if (!_isBusinessNameEmpty(businessName) ||
        !_isBusinessAddressEmpty(businessAddress)) {
      setState(() {
        _isFormValid = false;
      });
      return;
    }

    if (_isBusinessNameEmpty(businessName) &&
        _isBusinessAddressEmpty(businessAddress)) {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$businessAddress');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);

          DocumentReference businessDocRef = FirebaseFirestore.instance
              .collection('business')
              .doc(widget.userId);

          businessDocRef.update({
            'businessName': businessName,
            'businessAddress': businessAddress,
            'latitude': lat,
            'longitude': lon,
          }).then((value) {
            print('Business information stored successfully!');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BusinessHomeScreen()),
            );
          }).catchError((error) {
            setState(() {
              _isFormValid = false;
            });
            print('Failed to store business information: $error');
          });
        }
      } else {
        setState(() {
          _isFormValid = false;
        });
        print('Failed to fetch coordinates for the address');
      }
    }
  }

  bool _isBusinessNameEmpty(String value) {
    if (value.isEmpty) {
      setState(() {
        _businessNameError = 'Business name is required.';
      });
      return false;
    }
    return true;
  }

  bool _isBusinessAddressEmpty(String value) {
    if (value.isEmpty) {
      setState(() {
        _businessAddressError = 'Business address is required.';
      });
      return false;
    }
    return true;
  }

  Future<List<String>> _getAddressSuggestions(String query) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final suggestions =
            data.map((item) => item['display_name'] as String).toList();
        return suggestions;
      } else {
        throw Exception(
            'Failed to load address suggestions. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load address suggestions: $e');
    }
  }

  void _updateAddressSuggestions(String query) {
    _getAddressSuggestions(query).then((suggestions) {
      // Show the suggestions to the user (e.g., using a ListView)
      print(suggestions);
      setState(() {
        _addressSuggestions = suggestions;
      });
    }).catchError((error) {
      print('Failed to load address suggestions: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Information'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Your Business Information',
                style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 20),
              Text(
                'Business Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _businessNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your business name',
                  errorText: _businessNameError,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Business Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  TextFormField(
                    controller: _businessAddressController,
                    decoration: InputDecoration(
                      hintText: 'Enter your business address',
                      errorText: _businessAddressError,
                    ),
                    onChanged: (query) {
                      _updateAddressSuggestions(query);
                    },
                  ),
                  SizedBox(height: 10),
                  if (_addressSuggestions.isNotEmpty)
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: _addressSuggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _addressSuggestions[index];
                          return ListTile(
                            title: Text(suggestion),
                            onTap: () {
                              setState(() {
                                _businessAddressController.text = suggestion;
                                _addressSuggestions = [];
                              });
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isFormValid ? null : saveBusinessInfo,
                child: Text('SAVE INFO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
