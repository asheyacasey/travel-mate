import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      DocumentReference businessDocRef =
          FirebaseFirestore.instance.collection('business').doc(widget.userId);

      businessDocRef.set({
        'businessName': businessName,
        'businessAddress': businessAddress,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Information'),
      ),
      body: Container(
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
            TextFormField(
              controller: _businessAddressController,
              decoration: InputDecoration(
                hintText: 'Enter your business address',
                errorText: _businessAddressError,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isFormValid ? null : saveBusinessInfo,
              child: Text('SAVE INFO'),
            ),
          ],
        ),
      ),
    );
  }
}
