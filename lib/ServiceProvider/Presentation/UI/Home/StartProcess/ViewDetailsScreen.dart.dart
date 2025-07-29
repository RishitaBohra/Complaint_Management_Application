import 'package:flutter/material.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';

class ViewDetailsScreen extends StatelessWidget {
  const ViewDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPicker.blueColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Details", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text("V", style: TextStyle(color: Colors.white)),
              ),
              title: Text("Vivek Goyal", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Free Plan"),
              trailing: Icon(Icons.notifications, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Complaint Number: 0001"),
                    const Text("Name: Vivek Goyal"),
                    const Text("Date: 05/07/2025"),
                    const Text("Complaint Type: Plumbing"),
                    const Text("Preferred Time: 02:00 PM to 05:00 PM"),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset('assets/sample_before.jpg', height: 150, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: ColorPicker.blueColor),
                      onPressed: () {
                        Navigator.pushNamed(context, '/endProcess');
                      },
                      child: const Text("End Process", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
