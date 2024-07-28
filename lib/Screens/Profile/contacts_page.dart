import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _getPermissions();
  }

  Future<void> _getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      _fetchContacts();
    }
  }

  Future<void> _fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts();
      setState(() {
        _contacts = contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _contacts.isEmpty
          ? const Center(
            child:  CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(0, 0xcf, 0x91, 1)),
              ),
          )
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0xcf, 0x91, 1),
                              borderRadius: BorderRadius.circular(
                                50,
                              ),
                            ),
                            width: 48,
                            height: 48,
                            child: Text(
                              contact.displayName[0],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    contact.displayName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: GoogleFonts.rubik(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 63, 63, 63),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (contact.phones.isNotEmpty)
                              Text(
                                contact.phones.first.number.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 63, 63, 63),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      // Column(
                      //   children: [
                      //     Container(
                      //       padding: const EdgeInsets.only(right: 16),
                      //       child: Text(
                      //         getTimeValue(chatInfo.lastMessageTime.toString()),
                      //         style: GoogleFonts.rubik(
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 12,
                      //           color: const Color.fromARGB(255, 157, 157, 157),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(height: 4,),
                      //     Container(
                      //       padding: const EdgeInsets.only(right: 16),
                      //       child: (chatInfo.numberNotSeenMessages! > 0)
                      //           ? Container(
                      //         //padding: const EdgeInsets.all(1),
                      //         decoration: BoxDecoration(
                      //           color: Colors.green,
                      //           borderRadius: BorderRadius.circular(6),
                      //         ),
                      //         width: 12,
                      //         height: 12,
                      //         child: Center(
                      //           child: Text(
                      //             '${chatInfo.numberNotSeenMessages!}',
                      //             style: const TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 8,
                      //             ),
                      //             textAlign: TextAlign.center,
                      //           ),
                      //         ),
                      //       ) : null,
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                );
                // return ListTile(
                //   title: Text(contact.displayName ?? ''),
                //   subtitle: Text(
                //     contact.phones.isNotEmpty
                //         ? contact.phones.first.number ?? ''
                //         : '',
                //   ),
                // );
              },
            ),
    );
  }
}
