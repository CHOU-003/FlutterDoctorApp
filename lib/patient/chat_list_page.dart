import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice/chat_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../doctor/model/doctor.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _chatListDatabase =
      FirebaseDatabase.instance.ref().child('ChatList');
  final DatabaseReference _doctorDatabase =
      FirebaseDatabase.instance.ref().child('Doctors');
  List<Doctor> _chatList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChatList();
  }

  Future<void> _fetchChatList() async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        final DatabaseEvent event = await _chatListDatabase.once();
        DataSnapshot snapshot = event.snapshot;
        List<Doctor> tempChatList = [];

        if (snapshot.value != null) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;
          for (var doctorId in values.keys) {
            Map<dynamic, dynamic> userChats = values[doctorId];
            if (userChats.containsKey(userId)) {
              final DatabaseEvent doctorEvent =
                  await _doctorDatabase.child(doctorId).once();
              DataSnapshot doctorSnapshot = doctorEvent.snapshot;
              if (doctorSnapshot.value != null) {
                Doctor doctor = Doctor.fromMap(
                    doctorSnapshot.value as Map<dynamic, dynamic>, doctorId);
                tempChatList.add(doctor);
              }
            }
          }
        }
        setState(() {
          _chatList = tempChatList;
          _isLoading = false;
        });
      } catch (error) {
        // handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.chatWith,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chatList.isEmpty
              ? Center(
                  child: Text(
                    AppLocalizations.of(context)!.noChats,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                )
              : ListView.builder(
                  itemCount: _chatList.length,
                  itemBuilder: (context, index) {
                    Doctor doctor = _chatList[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              doctorId: doctor.uid,
                              doctorName:
                                  '${doctor.firstName} ${doctor.lastName}',
                              patientId: _auth.currentUser!.uid,
                            ),
                          ));
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              doctor.firstName.isNotEmpty
                                  ? doctor.firstName[0].toUpperCase()
                                  : "?",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                          title: Text(
                            '${doctor.firstName} ${doctor.lastName}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            doctor.category,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey[500]),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
