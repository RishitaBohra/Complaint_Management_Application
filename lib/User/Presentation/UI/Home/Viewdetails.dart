// import 'package:flutter/material.dart';
// import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
// import 'package:amity_university/User/Presentation/model/complaint_model.dart';

// class ViewDetails extends StatefulWidget {
//   final Complaint complaint;

//   const ViewDetails({super.key, required this.complaint});

//   @override
//   State<ViewDetails> createState() => _ViewDetailsState();
// }

// class _ViewDetailsState extends State<ViewDetails> {
//   @override
//   Widget build(BuildContext context) {
//     final complaint = widget.complaint;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorPicker.blueColor,
//         title: const Text('Complaint Details', style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             detailTile("📅 Date", complaint.date),
//             const Divider(),

//             detailTile("🆔 Complaint Number", complaint.complaintNumber),
//             const Divider(),

//             detailTile("👤 Complainant Name", complaint.name),
//             const Divider(),

//             detailTile("📞 Contact Number", complaint.contact),
//             const Divider(),

//             detailTile("📍 Block / Location", complaint.block),
//             const Divider(),

//             detailTile("⚠️ Complaint Type", complaint.complaintType),
//             const Divider(),

//             if (complaint.timeCarpentryCivil != null && complaint.timeCarpentryCivil!.isNotEmpty)
//               detailTile("🛠️ Time Slot (Carpentry/Civil)", complaint.timeCarpentryCivil!),
//             if (complaint.timePlumbingElectrical != null &&
//                 complaint.timePlumbingElectrical!.isNotEmpty)
//               detailTile("🔌 Time Slot (Plumbing/Electrical)", complaint.timePlumbingElectrical!),

//             const Divider(),

//             detailTile("📝 Description", complaint.description),
//             const Divider(),

//             detailTile("🚦 Status", complaint.status),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget detailTile(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "$title: ",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: Text(value, softWrap: true),
//           ),
//         ],
//       ),
//     );
//   }
// }
// ViewDetails.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/User/Presentation/model/complaint_model.dart';
import 'package:amity_university/api_service_baseurl.dart';

class ViewDetails extends StatefulWidget {
  final Complaint complaint;

  const ViewDetails({super.key, required this.complaint});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  late Complaint complaint;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    complaint = widget.complaint; 
    fetchLatestComplaint();
  }

  Future<void> fetchLatestComplaint() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        debugPrint("❌ No token found in SharedPreferences.");
        setState(() {
          isLoading = false;
          isError = true;
        });
        return;
      }

      debugPrint("✅ Fetching complaint with ID: ${complaint.id}");
      final url = "${baseUrl}api/complaints/${complaint.id}";
      debugPrint("🔗 API URL: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("🔍 Status Code: ${response.statusCode}");
      debugPrint("📄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'];

        if (data is List && data.isNotEmpty) {
          setState(() {
            complaint = Complaint.fromJson(data[0]);
            isLoading = false;
            isError = false;
          });
        } else {
          setState(() {
            isLoading = false;
            isError = true;
          });
        }
      } else {
        debugPrint("❌ Failed to fetch complaint: ${response.statusCode}");
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (e) {
      debugPrint("❌ Error fetching complaint details: $e");
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPicker.blueColor,
        title: const Text('Complaint Details', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: ColorPicker.blueColor))
          : isError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Failed to load complaint details."),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: ColorPicker.blueColor),
                        onPressed: fetchLatestComplaint,
                        child: const Text("Retry", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      detailTile("📅 Date", complaint.date),
                      const Divider(),

                      detailTile("🆔 Complaint Number", complaint.complaintNumber),
                      const Divider(),

                      detailTile("👤 Complainant Name", complaint.name),
                      const Divider(),

                      detailTile("📞 Contact Number", complaint.contact),
                      const Divider(),

                      detailTile("📍 Block / Location", complaint.block),
                      const Divider(),

                      detailTile("⚠️ Complaint Type", complaint.complaintType),
                      const Divider(),

                      if (complaint.timeCarpentryCivil != null &&
                          complaint.timeCarpentryCivil!.isNotEmpty)
                        detailTile("🛠️ Time Slot (Carpentry/Civil)", complaint.timeCarpentryCivil!),
                      if (complaint.timePlumbingElectrical != null &&
                          complaint.timePlumbingElectrical!.isNotEmpty)
                        detailTile("🔌 Time Slot (Plumbing/Electrical)",
                            complaint.timePlumbingElectrical!),

                      const Divider(),

                      detailTile("📝 Description", complaint.description),
                      const Divider(),

                      detailTile("🚦 Status", complaint.status),
                    ],
                  ),
                ),
    );
  }

  Widget detailTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value, softWrap: true),
          ),
        ],
      ),
    );
  }
}
