import 'package:flutter/material.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/User/Presentation/model/complaint_model.dart';

class ViewComplaintDetails extends StatefulWidget {
  final Complaint complaint;

  const ViewComplaintDetails({super.key, required this.complaint});

  @override
  State<ViewComplaintDetails> createState() => _ViewComplaintDetailsState();
}

class _ViewComplaintDetailsState extends State<ViewComplaintDetails> {
  @override
  Widget build(BuildContext context) {
    final complaint = widget.complaint;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPicker.blueColor,
        title: const Text('Complaint Details', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
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

            if (complaint.timeCarpentryCivil.isNotEmpty)
              detailTile("🛠️ Time Slot (Carpentry/Civil)", complaint.timeCarpentryCivil),
            if (complaint.timePlumbingElectrical.isNotEmpty)
              detailTile("🔌 Time Slot (Plumbing/Electrical)", complaint.timePlumbingElectrical),

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