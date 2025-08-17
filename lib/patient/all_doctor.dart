import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice/doctor/doctor_details_page.dart';
import 'package:practice/doctor/model/doctor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:practice/doctor/widget/doctor_card.dart';

class AllDoctor extends StatefulWidget {
  const AllDoctor({super.key});

  @override
  State<AllDoctor> createState() => _AllDoctorState();
}

class _AllDoctorState extends State<AllDoctor> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Doctors');
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    await _database.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      List<Doctor> tmpDoctors = [];
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          Doctor doctor = Doctor.fromMap(value, key);
          tmpDoctors.add(doctor);
        });
      }
      setState(() {
        _doctors = tmpDoctors;
        _filteredDoctors = tmpDoctors;
        _isLoading = false;
      });
    });
  }

  void _filterDoctors(String query) {
    final results = _doctors.where((doctor) {
      return doctor.lastName.toLowerCase().contains(query.toLowerCase()) ||
          doctor.city.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredDoctors = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.topDoctors,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: _filterDoctors,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: AppLocalizations.of(context)!.searchDoctor,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // Danh sách bác sĩ
                Expanded(
                  child: _filteredDoctors.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noResultsFound,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredDoctors.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorDetailPage(
                                          doctor: _filteredDoctors[index]),
                                    ),
                                  );
                                },
                                child:
                                    DoctorCard(doctor: _filteredDoctors[index]),
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
