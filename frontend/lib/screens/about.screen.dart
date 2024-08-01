import 'package:flutter/material.dart';
import 'package:inventory/widgets/scaffold.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "About",
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'About Inventory',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Inventory is a new Flutter project aimed at providing a seamless and efficient way to manage your inventory.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Our Mission',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Our mission is to simplify inventory management with a user-friendly interface and powerful features.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Features',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Easy-to-use interface'),
                Text('• NFC integration for quick item scanning'),
                Text('• Support for QR codes'),
                Text('• Cloud synchronization'),
                Text('• Detailed reporting and analytics'),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Contact Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'If you have any questions or feedback, please contact us at support@inventoryapp.com.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
