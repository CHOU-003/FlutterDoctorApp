import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'model/booking.dart';


class DoctorRequestsPage extends StatefulWidget {
  const DoctorRequestsPage({super.key});

  @override
  State<DoctorRequestsPage> createState() => _DoctorRequestsPageState();
}

class _DoctorRequestsPageState extends State<DoctorRequestsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _requestDatabase =
      FirebaseDatabase.instance.ref().child('Requests');
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    String? currentUserId = _auth.currentUser?.uid;
    if (currentUserId != null) {
      await _requestDatabase
          .orderByChild('receiver')
          .equalTo(currentUserId)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> bookingMap =
              event.snapshot.value as Map<dynamic, dynamic>;
          _bookings.clear();
          bookingMap.forEach((key, value) {
            _bookings.add(Booking.fromMap(Map<String, dynamic>.from(value)));
          });
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.doctorRequests),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.noBooking,))
              : ListView.builder(
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    return ListTile(
                      title: Text(booking.description),
                      subtitle:
                          Text('Date: ${booking.date} Time: ${booking.time}'),
                      trailing: Text(booking.status),
                      onTap: () =>
                          _showStatusDialog(booking.id, booking.status),
                    );
                  }),
    );
  }

  void _showStatusDialog(String requestId, String currentStatus) {
    final loc = AppLocalizations.of(context)!;

    List<String> statuses = [
      loc.statusAccepted,
      loc.statusRejected,
      loc.statusCompleted,
    ];

    String selectedStatus = currentStatus;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.updateRequestStatus),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.selectStatus,),
                  SizedBox(height: 16.0),
                  Column(
                    children: List.generate(statuses.length, (index) {
                      return RadioListTile<String>(
                        title: Text(statuses[index]),
                        value: statuses[index],
                        groupValue: selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel,),
                ),
                TextButton(
                  onPressed: () async {
                    await _updateRequestStatus(requestId, selectedStatus);
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.updateStatus),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateRequestStatus(String requestId, String status) async {
    await _requestDatabase.child(requestId).update({
      'status': status,
    });
    await _fetchBookings();
  }
}
