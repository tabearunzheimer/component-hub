import 'package:flutter/material.dart';
import 'package:inventory/services/nfc.service.dart';
import 'package:inventory/widgets/scaffold.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.title});

  final String title;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  NFCService nfc = NFCService();
  ValueNotifier<dynamic> result = ValueNotifier(null);
  int? partId;

  @override
  void initState() {
    nfc.tagRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // check if you can read line by line from nfc to create uri_launcher
    return CustomScaffold(
      title: "Scanner",
      index: 1,
      body: nfc.buildWidget(
        Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  size: 250,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 0.3,
                  child: const Text(
                      "To read an NFC Tag, enable NFC on your device and hold the device close to the Tag."),
                ),
                ValueListenableBuilder<List<String>>(
                  valueListenable: nfc.result,
                  builder: (context, value, _) {
                    return value.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/parts-page', arguments: partId);
                            },
                            child: SingleChildScrollView(
                              child: Card(
                                elevation: 10,
                                shadowColor: Colors.grey,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: value.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return const ListTile(
                                        title: Text(
                                          "Tag Info",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                    RegExp myRegExp =
                                        RegExp(r'Component Id: (\d+)');
                                    RegExpMatch? match =
                                        myRegExp.firstMatch(value[2]);
                                    partId = match?.group(1) != null
                                        ? int.parse(match!.group(1)!)
                                        : 1;

                                    return ListTile(
                                      title: Text(value[index - 1]),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        : const CircularProgressIndicator();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nfc.dispose();
    super.dispose();
  }
}
