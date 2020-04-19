import 'dart:convert';

import 'package:contact/model/contact_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ContactService {
  static const Root = 'http://192.168.43.36/flutter_template/index.php';

  static Future<ContactModel> uploadUserContacts(
      {@required Map<String, dynamic> contactsMap}) async {
    try {
      //! converts contacts map to json string
      //! but this is not required since the HTTP Post request
      //! requires its body to be a Map type
      final _encodedContactsJson = json.encode(contactsMap);

      final _response = await http.post(Root, body: contactsMap);

      if (200 == _response.statusCode) {
        final _jsonMap = json.decode(_response.body);

        // this determines the type data returned from the server
        // which can be a success indication...
        // here i am assuming it returns the same list of contacts uploaded
        return ContactModel.fromJson(_jsonMap);
      } else {
        throw '${_response.statusCode} was returned by the server';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
