import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;

class Services {
  static const Root = 'http://192.168.43.36/flutter_template/index.php';
  static const _ADMIN_ADD_MEMBER = 'ADMIN_ADD_CONTACT';

  static Future<String> addNewUser(
      String displayName, String prefix, String suffix, String jobTitle) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADMIN_ADD_MEMBER;
      map['displayName'] = displayName;
      map['prefix'] = prefix;
      map['suffix'] = suffix;
      map['jobTitle'] = jobTitle;

      final response = await http.post(Root, body: map);
      print('CONTACT User Response:${response.body}');

      if (200 == response.statusCode) {
        //List<Contact> list= parseResponseUser(response.body);

        return response.body;
      } else {
        return "An error occured";
      }
    } catch (e) {
      return ' Server issue';
    }
  }

  static List<Contact> parseResponseUser(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Contact>((json) => Contact.fromMap(json)).toList();
  }
}
