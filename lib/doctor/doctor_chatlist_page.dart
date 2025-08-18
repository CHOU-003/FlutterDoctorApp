import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:practice/chat_screen.dart';
import 'package:practice/doctor/model/patient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorChatlistPage extends StatefulWidget {
  const DoctorChatlistPage({super.key});

  @override
  State<DoctorChatlistPage> createState() => _DoctorChatlistPageState();
}

class _DoctorChatlistPageState extends State<DoctorChatlistPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _chatListDatabase =
      FirebaseDatabase.instance.ref().child('ChatList');
  final DatabaseReference _patientsDatabase =
      FirebaseDatabase.instance.ref().child('Patients');

  List<Patient> _chatList = [];
  bool _isLoading = true;
  late String doctorId;

  @override
  void initState() {
    super.initState();
    doctorId = _auth.currentUser?.uid ?? '';
    _fetchChatList();
  }

  Future<void> _fetchChatList() async {
    if (doctorId.isNotEmpty) {
      try {
        final DatabaseEvent event =
            await _chatListDatabase.child(doctorId).once();
        DataSnapshot snapshot = event.snapshot;
        List<Patient> tempChatList = [];

        if (snapshot.value != null) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;

          for (var userId in values.keys) {
            final DatabaseEvent patientEvent =
                await _patientsDatabase.child(userId).once();
            DataSnapshot patientSnapshot = patientEvent.snapshot;
            if (patientSnapshot.value != null) {
              Map<dynamic, dynamic> patientMap =
                  patientSnapshot.value as Map<dynamic, dynamic>;
              tempChatList
                  .add(Patient.fromMap(Map<String, dynamic>.from(patientMap)));
            }
          }
        }
        setState(() {
          _chatList = tempChatList;
          _isLoading = false;
        });
      } catch (error) {
        // TODO: show error message
      }
    }
  }

  Widget _buildAvatar(Patient patient) {
    // Nếu có avatar thì dùng ảnh
    if (patient.profileImageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 26,
        backgroundImage: NetworkImage(patient.profileImageUrl),
      );
    } else {
      // Nếu không có avatar => lấy chữ cái đầu trong tên
      String initials = "";
      if (patient.firstName.isNotEmpty) {
        initials = patient.firstName[0].toUpperCase();
      } else if (patient.lastName.isNotEmpty) {
        initials = patient.lastName[0].toUpperCase();
      } else {
        initials = "?";
      }

      return CircleAvatar(
        radius: 26,
        backgroundColor: Colors.blueAccent.shade200,
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.chatWith,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 3,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text("Đang tải danh sách chat...",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ))
          : _chatList.isEmpty
              ? Center(
                  child: Text(
                    loc.noChats,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _chatList.length,
                  itemBuilder: (context, index) {
                    final patient = _chatList[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              doctorId: doctorId,
                              patientId: patient.uid,
                              patientName:
                                  '${patient.firstName} ${patient.lastName}',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              _buildAvatar(patient),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${patient.firstName} ${patient.lastName}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Nhấn để bắt đầu trò chuyện",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chat_bubble_outline,
                                  color: Colors.blueAccent, size: 26),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
    );
  }
}
