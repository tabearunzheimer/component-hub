import 'package:flutter/material.dart';
import 'package:inventory/main.dart';
import 'package:inventory/widgets/responsive.device.dart';
import 'package:inventory/widgets/scaffold.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;
  static String fullUrl = "";

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _serverMethod = "http://";
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    MyApp.sharedPref.getServerURL();
    _urlController.text =
        SettingsPage.fullUrl.substring(SettingsPage.fullUrl.indexOf("//") + 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Settings",
      index: 2,
      body: ResponsiveDeviceLayout(
        mobile: buildMobile(),
        tablet: buildMobile(),
        desktop: buildDesktop(),
      ),
    );
  }

  buildUrl() {
    setState(() {
      SettingsPage.fullUrl = _serverMethod + _urlController.text;
      MyApp.sharedPref.saveServerURL(_serverMethod + _urlController.text);
      print('savedf');
    });
  }

  Widget buildMobile() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          ListTile(
            title: Text(
              "Server URL",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          ListTile(
            title: Row(
              children: [
                DropdownButton<String>(
                  value: _serverMethod,
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _serverMethod = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem<String>(
                      value: "http://",
                      child: Text("http://"),
                    ),
                    DropdownMenuItem<String>(
                      value: "https://",
                      child: Text("https://"),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your server IP or URL',
                    ),
                    controller: _urlController,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                IconButton(
                    onPressed: () => buildUrl(), icon: const Icon(Icons.save)),
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("About"),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Impressum"),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Datenschutz"),
            onTap: () {},
          ),
          const Divider(),
          const Text(
            "2024 \u00a9 Tabea Runzheimer",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildDesktop() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            const Text("Server URL"),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            DropdownButton<String>(
              value: _serverMethod,
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  _serverMethod = value!;
                });
              },
              items: const [
                DropdownMenuItem<String>(
                  value: "http://",
                  child: Text("http://"),
                ),
                DropdownMenuItem<String>(
                  value: "https://",
                  child: Text("https://"),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your server IP or URL',
                ),
                controller: _urlController,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            IconButton(onPressed: () => buildUrl, icon: const Icon(Icons.save)),
            const Padding(
              padding: EdgeInsets.only(right: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTablet() {
    return buildMobile();
  }
}
