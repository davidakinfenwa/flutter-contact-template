import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';

class Constants {
  static const ADMIN_ADD_MEMBER = 'ADMIN_ADD_CONTACT';
}

class ContactModel {
  final List<Contact> contacts;

  const ContactModel({@required this.contacts});

  /// deserialize json to ContactsModel
  factory ContactModel.fromJson(Map<String, dynamic> jsonMap) {
    return ContactModel(
      contacts: (jsonMap['data'] as List)?.map((data) {
            return Contact.fromMap(jsonMap);
          })?.toList() ??
          [],
    );
  }

  /// returns the map representation of contacts
  /// of this particular contacts instance
  /// if you are making use of all properties of the contact-entity,
  /// you can add them as key-value pairs here
  Map<String, dynamic> toJson() {
    final _contactsMap = contacts.map<Map<String, dynamic>>((contact) {
          return {
            'action': Constants.ADMIN_ADD_MEMBER,
            'displayName': contact.displayName,
            'phoneNumber': contact.phones.map((phone) {
                  return {
                    'label': phone.label,
                    'value': phone.value,
                  };
                }).toList() ??
                [],
            'prefix': contact.prefix,
            'suffix': contact.suffix,
            'jobTitle': contact.jobTitle,
          };
        }).toList() ??
        [];

    /// this is returned as a map with conatcts objact as a list of contact-map
    /// ie. { 'contacts': [ ... ] }
    return {'contacts': _contactsMap};
  }

  @override
  String toString() => 'ContactModel(contacts: $contacts)';
}
