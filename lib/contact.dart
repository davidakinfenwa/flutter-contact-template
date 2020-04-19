import 'package:contact/api/contact_service.dart';
import 'package:contact/contact_detail.dart';
import 'package:contact/model/contact_model.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  // List<Contact> _contacts;

  ContactModel _contactModel;

  // Contact contact;

  @override
  initState() {
    super.initState();
    // contact = Contact();
    refreshContacts();
    // getContact();
  }

  Future<ContactModel> _uploadAllContacts() async {
    // converts the contact model to Map<String, dynamic> type
   return await ContactService.uploadUserContacts(
        contactsMap: _contactModel.toJson());
  }

  void refreshContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      // Load without thumbnails initially.
      List<Contact> contacts =
          (await ContactsService.getContacts(withThumbnails: false)).toList();
      //      var contacts = (await ContactsService.getContactsForPhone("8554964652"))
      //          .toList();
      setState(() {
        _contactModel = ContactModel(contacts: contacts);
      });

      // Lazy load thumbnails after rendering initial contacts.
      for (final contact in contacts) {
        ContactsService.getAvatar(contact).then((avatar) {
          if (avatar == null) return; // Don't redraw if no change.
          setState(() => contact.avatar = avatar);
        });
      }

      // upload all gotten device-contacts to server
      await _uploadAllContacts();
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<void> updateContact() async {
    Contact ninja = _contactModel.contacts
        .toList()
        .firstWhere((contact) => contact.familyName.startsWith("Ninja"));
    ninja.avatar = null;
    await ContactsService.updateContact(ninja);

    refreshContacts();
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.restricted) {
      Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? Permission.unknown;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  // void getContact() {
  //   //print('this is the contact ${contact.displayName.toString()}');
  //   Services.addNewUser(
  //           contact.displayName.toString(),
  //           contact.prefix.toString(),
  //           contact.suffix.toString(),
  //           contact.jobTitle.toString())
  //       .then((result) {
  //     print('this is the length of the ${result.length}');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MSMPUSHER CONTACT')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("/add").then((_) {
            refreshContacts();
          });
        },
      ),
      body: SafeArea(
        child: _contactModel.contacts != null
            ? ListView.builder(
                itemCount: _contactModel.contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact c = _contactModel.contacts?.elementAt(index);
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ContactDetailsPage(c)));
                    },
                    leading: (c.avatar != null && c.avatar.length > 0)
                        ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                        : CircleAvatar(child: Text(c.initials())),
                    title: Text(c.displayName ?? ""),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class ItemsTile extends StatelessWidget {
  ItemsTile(this._title, this._items);
  final Iterable<Item> _items;
  final String _title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(title: Text(_title)),
        Column(
          children: _items
              .map(
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                    title: Text(i.label ?? ""),
                    trailing: Text(i.value ?? ""),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
