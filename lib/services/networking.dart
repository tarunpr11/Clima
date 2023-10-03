import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  String url;
  NetworkHelper(String this.url);

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    String data = response.body;
    return jsonDecode(data);
  }
}
