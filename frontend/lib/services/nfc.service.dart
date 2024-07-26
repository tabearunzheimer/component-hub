import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCService {
  ValueNotifier<List<String>> result = ValueNotifier([]);

  FutureBuilder<bool> buildWidget(Widget child) {
    return FutureBuilder<bool>(
        future: NfcManager.instance.isAvailable(),
        builder: (context, ss) => ss.data != true
            ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
            : child);
  }

  void tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var records = tag.data["ndef"]["cachedMessage"]["records"];
      List<String> tagValue = [];
      for (int i = 0; i < records.length; i++) {
        var payload = records[i]["payload"];
        String stringPayload = String.fromCharCodes(payload).substring(3);
        tagValue.add(stringPayload);
      }
      result.value = tagValue;
    });
  }

  void ndefWrite(String name, int componentId) {
    //PartModel part) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = ['Tag is not ndef writable'];
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText('Inventory Management'),
        NdefRecord.createText('Name: $name'), //${part.part}'),
        NdefRecord.createText('Component Id: $componentId'), //${part.part}'),
        NdefRecord.createText(
            'Click card to view Component Information'), //${part.part}'),

        // add text which links navigator route
        //NdefRecord.createUri(Uri.parse(SettingsPage.fullUrl ?? 'https://www.google.de')),
      ]);

      try {
        await ndef.write(message);
        result.value = ['Success to "Ndef Write"'];
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = [e.toString()];
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  void dispose() {
    NfcManager.instance.stopSession();
  }
}
