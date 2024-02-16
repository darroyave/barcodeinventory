import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends http.BaseClient {
  final http.Client _httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('token');

    request.headers['Authorization'] = 'Bearer $accessToken';

    return _httpClient.send(request);
  }
}
