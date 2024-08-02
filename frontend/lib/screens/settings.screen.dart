import 'package:flutter/material.dart';
import 'package:inventory/main.dart';
import 'package:inventory/services/generic.service.dart';
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
  late int minVersion;
  late int maxVersion;

  @override
  void initState() {
    minVersion = getExtendedVersionNumber("1.0.0");
    maxVersion = getExtendedVersionNumber("1.0.0");
    setServerUrl();
    super.initState();
  }

  setServerUrl() async {
    String? url = await MyApp.sharedPref.getServerURL();
    if (url == null) return;
    setState(() {
      _urlController.text = SettingsPage.fullUrl
          .substring(SettingsPage.fullUrl.indexOf("//") + 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Settings",
      index: 2,
      body: ResponsiveDeviceLayout(
        mobile: buildMobile(),
        tablet: buildMobile(),
        desktop: buildMobile(),
      ),
    );
  }

  buildUrl() async {
    String url = _serverMethod + _urlController.text;
    GenericAPI api = GenericAPI(baseUrl: url);
    var response = await api.getVersion();
    String? version = response['version'];
    SnackBar snackBar;

    if (version == null) {
      snackBar = const SnackBar(
        content: Text("Error trying to contact server"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    int? serverVersion = getExtendedVersionNumber(version);
    if (serverVersion >= minVersion && serverVersion <= maxVersion) {
      snackBar = const SnackBar(
        content: Text("Success!"),
      );
      setState(() {
        SettingsPage.fullUrl = url;
        MyApp.sharedPref.saveServerURL(url);
      });
    } else {
      snackBar = const SnackBar(
        content: Text("Error! Incompatible Server version"),
        backgroundColor: Colors.red,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            onTap: () {
              Navigator.of(context).pushNamed('/about');
            },
          ),
          ListTile(
            title: const Text("Legal Notice"),
            onTap: () {
              Navigator.of(context).pushNamed('/legal-notice');
            },
          ),
          ListTile(
            title: const Text("Privacy Policy"),
            onTap: () {
              Navigator.of(context).pushNamed('/privacy-policy');
            },
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
            IconButton(
                onPressed: () => buildUrl(), icon: const Icon(Icons.save)),
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

  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }
}
