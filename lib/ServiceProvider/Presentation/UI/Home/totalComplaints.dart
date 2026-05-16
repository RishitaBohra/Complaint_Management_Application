import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/User/Presentation/model/complaint_model.dart' as model;
import 'package:amity_university/api_service_baseurl.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/viewcomplaintdetails.dart';

class ViewAllComplaints extends StatefulWidget {
  const ViewAllComplaints({super.key});

  @override
  State<ViewAllComplaints> createState() => _ViewAllComplaintsState();
}

class _ViewAllComplaintsState extends State<ViewAllComplaints> {
  List<model.Complaint> complaints = [];
  bool isLoading = true;
  int? staffId; // Staff ID to fetch complaints for

  @override
  void initState() {
    super.initState();
    loadStaffIdAndFetchComplaints();
  }

  Future<void> loadStaffIdAndFetchComplaints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    staffId = prefs.getInt('staffId'); // Get staffId from SharedPreferences

    if (staffId != null) {
      await fetchComplaints();
    } else {
      debugPrint('❌ staffId not found in SharedPreferences');
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchComplaints() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}api/complaints/by-staff/$staffId"), // ✅ Dynamic staffId
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic>? data = decoded['data'];

        if (data != null && data.isNotEmpty) {
          List<model.Complaint> allComplaints = data
              .map((json) => model.Complaint.fromJson(json))
              .toList();

          // Sort complaints by createdAt (newest first)
          allComplaints.sort((a, b) {
            DateTime dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(2000);
            DateTime dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(2000);
            return dateB.compareTo(dateA);
          });

          setState(() {
            complaints = allComplaints;
            isLoading = false;
          });
        } else {
          debugPrint("ℹ️ No complaints found in API response.");
          setState(() => isLoading = false);
        }
      } else {
        debugPrint("❌ Failed to load complaints: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("❌ Error fetching complaints: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Complaints", style: TextStyle(color: Colors.white)),
        backgroundColor: ColorPicker.blueColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : complaints.isEmpty
              ? const Center(child: Text("No complaints found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];
                    return _buildComplaintCard(complaint);
                  },
                ),
    );
  }

  Widget _buildComplaintCard(model.Complaint complaint) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Complaint",
                    style: TextStyle(color: ColorPicker.blueColor, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                  complaint.date ?? '',
                  style: const TextStyle(color: ColorPicker.blueColor),
                ),
              ],
            ),
            const Divider(height: 10),
            const SizedBox(height: 8),
            Text(" Name: ${complaint.name ?? 'N/A'}"),
            Text(" Type: ${complaint.complaintType ?? 'N/A'}"),
            Text(" Location: ${complaint.block ?? 'N/A'}"),
            Text(" Contact: ${complaint.contact ?? 'N/A'}"),
            Text(" Description: ${complaint.description ?? 'N/A'}"),
            Text(" Status: ${complaint.status ?? 'Unknown'}"),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewComplaintDetails(complaint: complaint),
                    ),
                  );
                },
                child: const Text("View Details", style: TextStyle(color: ColorPicker.blueColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
