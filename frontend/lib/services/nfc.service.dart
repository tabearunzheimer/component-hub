import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

class NFCService {
  ValueNotifier<List<String>> result = ValueNotifier([]);

  FutureBuilder<bool> buildWidget(Widget child) {
    return FutureBuilder<bool>(
      future: NfcManager.instance.isAvailable(),
      builder: (context, ss) =>
          ss.data != true ? Center(child: Text('NFC not available')) : child,
    );
  }

  void tagRead() {
    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      onDiscovered: (NfcTag tag) async {
        try {
          final ndef = Ndef.from(tag);
          if (ndef == null || ndef.cachedMessage == null) {
            result.value = ['No NDEF data found'];
            NfcManager.instance.stopSession();
            return;
          }
          final records = ndef.cachedMessage!.records;
          List<String> tagValue = [];
          for (final record in records) {
            final payload = record.payload;
            // Typically, the first 3 bytes are language codes in text records, so skip them:
            String stringPayload = String.fromCharCodes(payload.sublist(3));
            tagValue.add(stringPayload);
          }
          result.value = tagValue;
          NfcManager.instance.stopSession();
        } catch (e) {
          result.value = ['Error reading tag: $e'];
          NfcManager.instance.stopSession();
        }
      },
    );
  }

  void ndefWrite(String name, int componentId) {
    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      onDiscovered: (NfcTag tag) async {
        try {
          var ndef = Ndef.from(tag);
          if (ndef == null || !ndef.isWritable) {
            result.value = ['Tag is not ndef writable'];
            NfcManager.instance.stopSession();
            return;
          }

          final message = NdefMessage(records: [
            _createTextRecord('Inventory Management'),
            _createTextRecord('Name: $name'),
            _createTextRecord('Component Id: $componentId'),
            _createTextRecord('Click card to view Component Information'),
          ]);

          await ndef.write(message: message);
          result.value = ['Success'];
          NfcManager.instance.stopSession();
        } catch (e) {
          result.value = ['Write failed: $e'];
          NfcManager.instance.stopSession();
        }
      },
    );
  }

NdefRecord _createTextRecord(String text) {
  return NdefRecord(
    typeNameFormat: TypeNameFormat.wellKnown,
    type: Uint8List.fromList([0x54]), // 'T' for text record
    identifier: Uint8List(0),         // empty identifier
    payload: _encodeTextPayload(text),
  );
}


  Uint8List _encodeTextPayload(String text) {
    final languageCode = 'en';
    final languageCodeBytes = Uint8List.fromList(languageCode.codeUnits);
    final textBytes = Uint8List.fromList(text.codeUnits);
    final payload = Uint8List(1 + languageCodeBytes.length + textBytes.length);

    payload[0] = languageCodeBytes.length;
    payload.setRange(1, 1 + languageCodeBytes.length, languageCodeBytes);
    payload.setRange(1 + languageCodeBytes.length, payload.length, textBytes);

    return payload;
  }

  
  void dispose() {
    NfcManager.instance.stopSession();
  }
}
