import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/custom_avatar.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/features/contacts/services/contacts_services.dart';
import 'package:flutter_chat_app/models/contact.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ContactsServices contactsServices = ContactsServices();
  List<Contact> contacts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAllUser();
  }

  void fetchAllUser() async {
    setState(() {
      isLoading = true;
    });
    contacts = await contactsServices.getAllUsers(context: context);
    setState(() {
      isLoading = false;
    });
  }

  void addFriend(String id) {
    contactsServices.sendFriendRequest(
      context: context,
      id: id,
      onSuccess: () {
        int index = contacts.indexWhere((Contact contact) => contact.id == id);
        setState(() {
          contacts[index] = contacts[index].copyWith(isRequested: true);
        });
      },
    );
  }

  void cancelFriendRequest(String id) {
    contactsServices.cancelFriendRequest(
      context: context,
      id: id,
      onSuccess: () {
        int index = contacts.indexWhere((Contact contact) => contact.id == id);
        setState(() {
          contacts[index] = contacts[index].copyWith(isRequested: false);
        });
      },
    );
  }

  void removeFriend(String id) {
    contactsServices.removeFriend(
      context: context,
      id: id,
      onSuccess: () {
        int index = contacts.indexWhere((Contact contact) => contact.id == id);
        setState(() {
          contacts[index] = contacts[index].copyWith(
            isRequested: false,
            isFriend: false,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loader()
        : Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "All Users",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = contacts[index];
                      return ListTile(
                        leading: SizedBox(
                          height: double.infinity,
                          child: CustomAvatar(
                            username: contact.username[0].toUpperCase(),
                          ),
                        ),
                        title: Text(
                          contact.username,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          contact.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            if (contact.isFriend == false &&
                                contact.isRequested == false)
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Icon(
                                      Icons.group_add,
                                      color: Colors.black,
                                    ),
                                    Text("Add Friend"),
                                  ],
                                ),
                                onTap: () => addFriend(contact.id),
                              ),
                            if (contact.isFriend == false &&
                                contact.isRequested == true)
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Icon(
                                      Icons.group_add,
                                      color: Colors.black,
                                    ),
                                    Text("  Cancel Request"),
                                  ],
                                ),
                                onTap: () => cancelFriendRequest(contact.id),
                              ),
                            if (contact.isFriend)
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Icon(
                                      Icons.group_add,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Remove Friend",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                onTap: () => removeFriend(contact.id),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
