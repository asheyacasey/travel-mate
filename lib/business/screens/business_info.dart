import 'package:flutter/material.dart';

class BusinessInfoScreen extends StatelessWidget {
  final String? userId;

  const BusinessInfoScreen({Key? key, this.userId}) : super(key: key);

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
                // Add your logic here for capturing the business name
                ),
            SizedBox(height: 20),
            Text(
              'Business Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
                // Add your logic here for capturing the business address
                ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your logic here for handling the next steps after entering business information
              },
              child: Text('NEXT'),
            ),
          ],
        ),
      ),
    );
  }
}
