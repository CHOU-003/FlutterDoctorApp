import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:practice/auth/login_page.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({super.key});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, int>> _getRequestStats() async {
    final ref = FirebaseDatabase.instance.ref().child('Requests');
    final snapshot = await ref.get();

    Map<String, int> dateCounts = {};

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        final item = Map<String, dynamic>.from(value);
        final date = item['date'];
        if (date != null) {
          dateCounts[date] = (dateCounts[date] ?? 0) + 1;
        }
      });
    }

    return dateCounts;
  }

  Widget buildBarChart(Map<String, int> data) {
    final sortedKeys = data.keys.toList()..sort();
    final barGroups = sortedKeys.asMap().entries.map((entry) {
      int index = entry.key;
      String key = entry.value;
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(toY: data[key]!.toDouble(), color: Colors.blue)
      ]);
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < sortedKeys.length) {
                  return Text(sortedKeys[index].substring(3)); // chỉ lấy MM/dd
                }
                return Text('');
              },
              reservedSize: 28,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
      ),
    );
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doc Profile'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _getRequestStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No request data available'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Biểu đồ số yêu cầu theo ngày trong tháng',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(child: buildBarChart(snapshot.data!)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
