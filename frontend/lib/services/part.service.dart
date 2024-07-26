import 'package:inventory/models/part.model.dart';
import 'package:inventory/screens/settings.screen.dart';
import 'package:inventory/services/api.service.dart';
import 'package:http/http.dart' as http;

class PartsService extends APIService {
  Future<List<PartModel>> getParts() async {
    List<dynamic> response = await requestWrapper(
      http.get(
        Uri.parse('${SettingsPage.fullUrl}/parts'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      ),
    );
    List<PartModel> data = [];
    for (Map<String, dynamic> part in response) {
      data.add(PartModel.fromJson(part));
    }
    return data;
  }

  Future<int> postPart(PartModel part) async {
    final response = await requestWrapper(
      http.post(
        Uri.parse('${SettingsPage.fullUrl}/part'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: part.toString(),
      ),
    );

    // TODO: returns id
    return 0;
  }

  Future<int> deletePart(int? id, String? part) async {
    final response = await requestWrapper(
      http.delete(
        Uri.parse('${SettingsPage.fullUrl}/part'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: (id != null) ? {"id": id} : {"part": "part"},
      ),
    );
    // TODO: handle response
    return 0;
  }

  Future<int> patchPart(String key, dynamic data) async {
    final response = await requestWrapper(
      http.patch(
        Uri.parse('${SettingsPage.fullUrl}/part'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: {key: data},
      ),
    );
    // TODO: handle response
    return 0;
  }

  Future<int> putPart(PartModel part) async {
    final response = await requestWrapper(
      http.put(
        Uri.parse('${SettingsPage.fullUrl}/part'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: part.toString(),
      ),
    );
    // TODO: handle response
    return 0;
  }
}
