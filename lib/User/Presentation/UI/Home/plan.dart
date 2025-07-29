import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:flutter/material.dart';


class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Plan", style: TextStyle(color: Colors.white),),
        backgroundColor: ColorPicker.blueColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Free Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("₹0/month", style: TextStyle(fontSize: 14, )),
                  SizedBox(height: 10),

                  

                  Text("• File complaints"),
                  Text("• View complaint history"),
                ],
              ),
            ),

            SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Paid Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("₹99/month", style: TextStyle(fontSize: 14, color: Colors.black)),
                  SizedBox(height: 10),
                  Text("• File complaints"),
                  Text("• View complaint history"),
                  Text("• Priority support"),
                  Text("• Faster resolution"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
