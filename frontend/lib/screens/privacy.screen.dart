import 'package:flutter/material.dart';
import 'package:inventory/widgets/scaffold.dart';

class PrivacyPage extends StatefulWidget {
  PrivacyPage({super.key, required this.title});

  final String title;

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Privacy Notice",
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'Privacy Notice',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Effective Date: July 28, 2024',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'This privacy notice for Inventory ("Company," "we," "us," or "our"), '
            'describes how and why we might collect, store, use, and/or share ("process") your information when you use our services ("Services"), '
            'such as when you:',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '• Visit our website at inventoryapp.com, or any website of ours that links to this privacy notice'),
                Text(
                    '• Use our mobile application (Inventory), or any other application of ours that links to this privacy notice'),
                Text(
                    '• Engage with us in other related ways, including any sales, marketing, or events'),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Questions or concerns? Reading this privacy notice will help you understand your privacy rights and choices. '
            'If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, '
            'please contact us at support@inventoryapp.com.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'SUMMARY OF KEY POINTS',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'This summary provides key points from our privacy notice, but you can find out more details about any of these topics by clicking the link following each key point or by using our table of contents below to find the section you are looking for.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '• What personal information do we process? When you visit, use, or navigate our Services, we may process personal information depending on how you interact with Inventory and the Services, the choices you make, and the products and features you use.'),
                Text(
                    '• Do we process any sensitive personal information? We do not process sensitive personal information.'),
                Text(
                    '• Do you receive any information from third parties? We do not receive any information from third parties.'),
                Text(
                    '• How do you process my information? We process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with the law. We may also process your information for other purposes with your consent. We process your information only when we have a valid legal reason to do so.'),
                Text(
                    '• How do we keep your information safe? We have organizational and technical processes and procedures in place to protect your personal information. However, no electronic transmission over the internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information.'),
                Text(
                    '• What are your rights? Depending on where you are located geographically, the applicable privacy law may mean you have certain rights regarding your personal information.'),
                Text(
                    '• How do I exercise my rights? The easiest way to exercise your rights is by contacting us. We will consider and act upon any request in accordance with applicable data protection laws.'),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Want to learn more about what Inventory does with any information we collect? Click here to review the notice in full.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
