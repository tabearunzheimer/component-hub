import 'package:flutter/material.dart';
import 'package:inventory/widgets/scaffold.dart';

class LegalNoticePage extends StatefulWidget {
  @override
  _LegalNoticePageState createState() => _LegalNoticePageState();
}

class _LegalNoticePageState extends State<LegalNoticePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Legal Notice",
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'Legal Notice',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Effective Date: July 28, 2024',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Welcome to Inventory. This legal notice governs your use of our application and services.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '1. Acceptance of Terms',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'By accessing and using our application, you accept and agree to be bound by the terms and provision of this agreement. '
            'If you do not agree to abide by the above, please do not use this service.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '2. Intellectual Property',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'The design and content of Inventory are protected by intellectual property laws. You may not use our intellectual property '
            'without our express written consent.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '3. Limitation of Liability',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Inventory shall not be liable for any indirect, incidental, special, or consequential damages, or any loss of revenue or profits '
            'arising under or relating to this agreement.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '4. Changes to the Legal Notice',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'We reserve the right to modify this legal notice at any time. Any changes will be posted on this page and will be effective immediately upon posting.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
