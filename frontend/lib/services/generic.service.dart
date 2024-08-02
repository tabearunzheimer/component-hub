import 'package:inventory/services/api.service.dart';
import 'package:http/http.dart' as http;

class GenericAPI extends APIService {
  final String baseUrl;
  GenericAPI({required this.baseUrl});

  Future<dynamic> getVersion() {
    return requestWrapper(http.get(Uri.parse(baseUrl)));
  }
}
