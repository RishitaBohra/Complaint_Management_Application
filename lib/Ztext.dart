// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:amity_university/model/complaint_model.dart';
// // // // import 'package:amity_university/provider/complaint_provider.dart';
// // // // import 'package:amity_university/Presentation/Constants/ColorPicker.dart';
// // // // import 'package:amity_university/Presentation/UI/Home/Home.dart';

// // // // class ComplaintFormScreen extends ConsumerStatefulWidget {
// // // //   const ComplaintFormScreen({super.key});

// // // //   @override
// // // //   ConsumerState<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
// // // // }

// // // // class _ComplaintFormScreenState extends ConsumerState<ComplaintFormScreen> {
// // // //   final _formKey = GlobalKey<FormState>();
// // // //   final TextEditingController nameController = TextEditingController();
// // // //   final TextEditingController dateController = TextEditingController();
// // // //   final TextEditingController contactController = TextEditingController();
// // // //   final TextEditingController blockController = TextEditingController();
// // // //   final TextEditingController descriptionController = TextEditingController();

// // // //   String? selectedComplaintType;
// // // //   String? preferredTimeCarpentry;
// // // //   String? preferredTimePlumbing;

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text("Technical Complaint Registration Form", style: TextStyle(color: Colors.white)),
// // // //         backgroundColor: ColorPicker.blueColor,
// // // //         iconTheme: const IconThemeData(color: Colors.white),
// // // //       ),
// // // //       body: SafeArea(
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.all(12),
// // // //           child: Form(
// // // //             key: _formKey,
// // // //             child: ListView(
// // // //               children: [
// // // //                 const Text(
// // // //                   "Please enter the below details correctly to lodge your maintenance related complaint.\n\n"
// // // //                   "Note: In case of an emergency, please contact the Maintenance Supervisor directly at "
// // // //                   "9772764090.",
// // // //                   style: TextStyle(fontSize: 14),
// // // //                 ),
// // // //                 const SizedBox(height: 20),
// // // //                 _buildTextField("Name *", nameController),
// // // //                 _buildDatePicker("Date *", dateController),
// // // //                 _buildTextField("Contact Number *", contactController, isPhone: true),
// // // //                 _buildTextField("Block/Flat Number *", blockController),
// // // //                 _buildRadioGroup("Complaint Type *", [
// // // //                   "Plumbing", "Electrical", "Carpentry", "Civil", "Other"
// // // //                 ], selectedComplaintType, (value) {
// // // //                   setState(() {
// // // //                     selectedComplaintType = value;
// // // //                   });
// // // //                 }),
// // // //                 _buildRadioGroup("Preferred Time for Carpentry/Civil", [
// // // //                   "09:00 AM to 01:00 PM", "02:00 PM to 05:00 PM"
// // // //                 ], preferredTimeCarpentry, (value) {
// // // //                   setState(() {
// // // //                     preferredTimeCarpentry = value;
// // // //                   });
// // // //                 }),
// // // //                 _buildRadioGroup("Preferred Time for Plumbing and Electrical", [
// // // //                   "09:00 AM to 01:00 PM", "02:00 PM to 05:00 PM", "05:00 PM to 07:00 PM"
// // // //                 ], preferredTimePlumbing, (value) {
// // // //                   setState(() {
// // // //                     preferredTimePlumbing = value;
// // // //                   });
// // // //                 }),
// // // //                 const SizedBox(height: 12),
// // // //                 const Text("Description *", style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                 const SizedBox(height: 5),
// // // //                 TextFormField(
// // // //                   controller: descriptionController,
// // // //                   maxLines: 4,
// // // //                   validator: (value) => value!.isEmpty ? "Required" : null,
// // // //                   decoration: InputDecoration(
// // // //                     hintText: "Enter your answer",
// // // //                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 20),
// // // //                 ElevatedButton(
// // // //                   style: ElevatedButton.styleFrom(
// // // //                     backgroundColor: Colors.red,
// // // //                     minimumSize: const Size(double.infinity, 50),
// // // //                   ),
// // // //                   onPressed: () {
// // // //                     if (_formKey.currentState!.validate()) {
// // // //                       final complaint = ComplaintModel(
// // // //                         name: nameController.text,
// // // //                         date: dateController.text,
// // // //                         contact: contactController.text,
// // // //                         block: blockController.text,
// // // //                         type: selectedComplaintType ?? '',
// // // //                         preferredTime: (selectedComplaintType == "Carpentry" || selectedComplaintType == "Civil")
// // // //                             ? preferredTimeCarpentry ?? ''
// // // //                             : preferredTimePlumbing ?? '',
// // // //                         description: descriptionController.text,
// // // //                       );

// // // //                       ref.read(submitComplaintProvider(complaint).future).then((_) {
// // // //                         ScaffoldMessenger.of(context).showSnackBar(
// // // //                           const SnackBar(content: Text("Complaint submitted successfully")),
// // // //                         );
// // // //                         Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
// // // //                       }).catchError((error) {
// // // //                         ScaffoldMessenger.of(context).showSnackBar(
// // // //                           SnackBar(content: Text("Error: ${error.toString()}")),
// // // //                         );
// // // //                       });
// // // //                     }
// // // //                   },
// // // //                   child: const Text("Submit", style: TextStyle(color: Colors.white)),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildTextField(String label, TextEditingController controller, {bool isPhone = false}) {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.symmetric(vertical: 8),
// // // //       child: TextFormField(
// // // //         controller: controller,
// // // //         keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
// // // //         validator: (value) => value!.isEmpty ? "Required" : null,
// // // //         decoration: InputDecoration(
// // // //           labelText: label,
// // // //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildDatePicker(String label, TextEditingController controller) {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.symmetric(vertical: 8),
// // // //       child: TextFormField(
// // // //         controller: controller,
// // // //         readOnly: true,
// // // //         validator: (value) => value!.isEmpty ? "Required" : null,
// // // //         decoration: InputDecoration(
// // // //           labelText: label,
// // // //           suffixIcon: const Icon(Icons.calendar_today),
// // // //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// // // //         ),
// // // //         onTap: () async {
// // // //           final pickedDate = await showDatePicker(
// // // //             context: context,
// // // //             initialDate: DateTime.now(),
// // // //             firstDate: DateTime(2020),
// // // //             lastDate: DateTime(2030),
// // // //           );
// // // //           if (pickedDate != null) {
// // // //             controller.text = "${pickedDate.day.toString().padLeft(2, '0')}-"
// // // //                               "${pickedDate.month.toString().padLeft(2, '0')}-"
// // // //                               "${pickedDate.year}";
// // // //           }
// // // //         },
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildRadioGroup(String title, List<String> options, String? groupValue, Function(String?) onChanged) {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         const SizedBox(height: 16),
// // // //         Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
// // // //         ...options.map(
// // // //           (option) => RadioListTile<String>(
// // // //             value: option,
// // // //             groupValue: groupValue,
// // // //             onChanged: onChanged,
// // // //             title: Text(option),
// // // //             visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';

// // // class ComplaintFormScreen extends StatefulWidget {
// // //   const ComplaintFormScreen({super.key});

// // //   @override
// // //   State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
// // // }

// // // class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
// // //   final nameController = TextEditingController();
// // //   final dateController = TextEditingController();
// // //   final contactController = TextEditingController();
// // //   final flatController = TextEditingController();
// // //   final descriptionController = TextEditingController();

// // //   String? complaintType;
// // //   String? timeCarpentryCivil;
// // //   String? timePlumbingElectrical;

// // //   final complaintOptions = [
// // //     "Plumbing",
// // //     "Electrical",
// // //     "Carpentry",
// // //     "Civil",
// // //     "Other"
// // //   ];

// // //   final timeSlotsCarpentryCivil = [
// // //     "09:00 AM to 01:00 PM",
// // //     "02:00 PM to 05:00 PM"
// // //   ];

// // //   final timeSlotsPlumbingElectrical = [
// // //     "09:00 AM to 01:00 PM",
// // //     "02:00 PM to 05:00 PM",
// // //     "05:00 PM to 07:00 PM"
// // //   ];

// // //   Future<void> _submitForm() async {
// // //     final body = {
// // //       "name": nameController.text,
// // //       "date": dateController.text,
// // //       "contact": contactController.text,
// // //       "block": flatController.text,
// // //       "complaintType": complaintType ?? "",
// // //       "timeCarpentryCivil": timeCarpentryCivil ?? "",
// // //       "timePlumbingElectrical": timePlumbingElectrical ?? "",
// // //       "description": descriptionController.text,
// // //       "complaintNumber": "0080", // static for now
// // //     };

// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse("http://192.168.0.23:3000/api/complaints"),
// // //         headers: {"Content-Type": "application/json"},
// // //         body: jsonEncode(body),
// // //       );

// // //       print("STATUS: ${response.statusCode}");
// // //       print("RESPONSE: ${response.body}");

// // //       final result = jsonDecode(response.body);
// // //       final status = result['status'] ?? false;
// // //       final message = result['message'] ?? 'No message';

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text(status ? "✅ $message" : "❌ $message")),
// // //       );
// // //     } catch (e) {
// // //       print("ERROR: $e");
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text("Error occurred: $e")),
// // //       );
// // //     }
// // //   }

// // //   Future<void> _pickDate() async {
// // //     final picked = await showDatePicker(
// // //       context: context,
// // //       initialDate: DateTime.now(),
// // //       firstDate: DateTime(2020),
// // //       lastDate: DateTime(2030),
// // //     );
// // //     if (picked != null) {
// // //       setState(() {
// // //         dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
// // //       });
// // //     }
// // //   }

// // //   Widget buildSectionTitle(String title) => Padding(
// // //         padding: const EdgeInsets.symmetric(vertical: 12),
// // //         child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// // //       );

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text("Technical Complaint Registration")),
// // //       body: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(children: [
// // //           buildSectionTitle("1. Name *"),
// // //           TextField(controller: nameController, decoration: const InputDecoration(hintText: "Enter your name")),

// // //           buildSectionTitle("2. Date *"),
// // //           TextField(
// // //             controller: dateController,
// // //             readOnly: true,
// // //             onTap: _pickDate,
// // //             decoration: const InputDecoration(hintText: "dd-mm-yyyy", suffixIcon: Icon(Icons.calendar_today)),
// // //           ),

// // //           buildSectionTitle("3. Contact Number *"),
// // //           TextField(
// // //             controller: contactController,
// // //             keyboardType: TextInputType.phone,
// // //             decoration: const InputDecoration(hintText: "Enter your number"),
// // //           ),

// // //           buildSectionTitle("4. Block/Flat Number *"),
// // //           TextField(controller: flatController, decoration: const InputDecoration(hintText: "Enter your block/flat")),

// // //           buildSectionTitle("5. Complaint Type *"),
// // //           ...complaintOptions.map((type) => RadioListTile(
// // //                 title: Text(type),
// // //                 value: type,
// // //                 groupValue: complaintType,
// // //                 onChanged: (val) => setState(() => complaintType = val),
// // //               )),

// // //           buildSectionTitle("6. Preferred Time for Carpentry/Civil"),
// // //           ...timeSlotsCarpentryCivil.map((slot) => RadioListTile(
// // //                 title: Text(slot),
// // //                 value: slot,
// // //                 groupValue: timeCarpentryCivil,
// // //                 onChanged: (val) => setState(() => timeCarpentryCivil = val),
// // //               )),

// // //           buildSectionTitle("7. Preferred Time for Plumbing and Electrical"),
// // //           ...timeSlotsPlumbingElectrical.map((slot) => RadioListTile(
// // //                 title: Text(slot),
// // //                 value: slot,
// // //                 groupValue: timePlumbingElectrical,
// // //                 onChanged: (val) => setState(() => timePlumbingElectrical = val),
// // //               )),

// // //           buildSectionTitle("8. Description *"),
// // //           TextField(
// // //             controller: descriptionController,
// // //             maxLines: 4,
// // //             decoration: const InputDecoration(
// // //               hintText: "Enter your complaint details",
// // //               border: OutlineInputBorder(),
// // //             ),
// // //           ),

// // //           const SizedBox(height: 24),
// // //           ElevatedButton(
// // //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
// // //             onPressed: _submitForm,
// // //             child: const Padding(
// // //               padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
// // //               child: Text("Submit", style: TextStyle(fontSize: 16)),
// // //             ),
// // //           ),
// // //         ]),
// // //       ),
// // //     );
// // //   }
// // // }
// // // complaint_form_emulator.dart





// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';

// // // class ComplaintFormScreen extends StatefulWidget {
// // //   const ComplaintFormScreen({super.key});

// // //   @override
// // //   State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
// // // }

// // // class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
// // //   final nameController = TextEditingController();
// // //   final dateController = TextEditingController();
// // //   final contactController = TextEditingController();
// // //   final flatController = TextEditingController();
// // //   final descriptionController = TextEditingController();

// // //   String? complaintType;
// // //   String? timeCarpentryCivil;
// // //   String? timePlumbingElectrical;

// // //   final complaintOptions = ["Plumbing", "Electrical", "Carpentry", "Civil", "Other"];
// // //   final timeSlotsCarpentryCivil = ["09:00 AM to 01:00 PM", "02:00 PM to 05:00 PM"];
// // //   final timeSlotsPlumbingElectrical = ["09:00 AM to 01:00 PM", "02:00 PM to 05:00 PM", "05:00 PM to 07:00 PM"];

// // //   Future<void> _submitForm() async {
// // //     final body = {
// // //       "name": nameController.text,
// // //       "date": dateController.text,
// // //       "contact": contactController.text,
// // //       "block": flatController.text,
// // //       "complaintType": complaintType ?? "",
// // //       "timeCarpentryCivil": timeCarpentryCivil ?? "",
// // //       "timePlumbingElectrical": timePlumbingElectrical ?? "",
// // //       "description": descriptionController.text,
// // //       "complaintNumber": "0080",
// // //     };

// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse("http://10.0.2.2:3000/api/complaints"), // ← Emulator IP
// // //         headers: {"Content-Type": "application/json"},
// // //         body: jsonEncode(body),
// // //       );

// // //       print("STATUS: ${response.statusCode}");
// // //       print("RESPONSE: ${response.body}");

// // //       final result = jsonDecode(response.body);
// // //       final status = result['status'] ?? false;
// // //       final message = result['message'] ?? 'No message';

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text(status ? "✅ $message" : "❌ $message")),
// // //       );
// // //     } catch (e) {
// // //       print("ERROR: $e");
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
// // //     }
// // //   }

// // //   Future<void> _pickDate() async {
// // //     final picked = await showDatePicker(
// // //       context: context,
// // //       initialDate: DateTime.now(),
// // //       firstDate: DateTime(2020),
// // //       lastDate: DateTime(2035),
// // //     );
// // //     if (picked != null) {
// // //       dateController.text =
// // //           "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
// // //     }
// // //   }

// // //   Widget buildSectionTitle(String title) => Padding(
// // //         padding: const EdgeInsets.symmetric(vertical: 12),
// // //         child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// // //       );

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text("Complaint Registration Form")),
// // //       body: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(children: [
// // //           buildSectionTitle("1. Name *"),
// // //           TextField(controller: nameController, decoration: const InputDecoration(hintText: "Enter your name")),

// // //           buildSectionTitle("2. Date *"),
// // //           TextField(
// // //             controller: dateController,
// // //             readOnly: true,
// // //             onTap: _pickDate,
// // //             decoration: const InputDecoration(hintText: "dd-mm-yyyy", suffixIcon: Icon(Icons.calendar_today)),
// // //           ),

// // //           buildSectionTitle("3. Contact Number *"),
// // //           TextField(controller: contactController, keyboardType: TextInputType.phone),

// // //           buildSectionTitle("4. Block/Flat Number *"),
// // //           TextField(controller: flatController),

// // //           buildSectionTitle("5. Complaint Type *"),
// // //           ...complaintOptions.map((type) => RadioListTile(
// // //                 title: Text(type),
// // //                 value: type,
// // //                 groupValue: complaintType,
// // //                 onChanged: (val) => setState(() => complaintType = val),
// // //               )),

// // //           buildSectionTitle("6. Preferred Time for Carpentry/Civil"),
// // //           ...timeSlotsCarpentryCivil.map((slot) => RadioListTile(
// // //                 title: Text(slot),
// // //                 value: slot,
// // //                 groupValue: timeCarpentryCivil,
// // //                 onChanged: (val) => setState(() => timeCarpentryCivil = val),
// // //               )),

// // //           buildSectionTitle("7. Preferred Time for Plumbing and Electrical"),
// // //           ...timeSlotsPlumbingElectrical.map((slot) => RadioListTile(
// // //                 title: Text(slot),
// // //                 value: slot,
// // //                 groupValue: timePlumbingElectrical,
// // //                 onChanged: (val) => setState(() => timePlumbingElectrical = val),
// // //               )),

// // //           buildSectionTitle("8. Description *"),
// // //           TextField(
// // //             controller: descriptionController,
// // //             maxLines: 4,
// // //             decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Enter your complaint"),
// // //           ),

// // //           const SizedBox(height: 20),
// // //           ElevatedButton(
// // //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
// // //             onPressed: _submitForm,
// // //             child: const Padding(
// // //               padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
// // //               child: Text("Submit", style: TextStyle(fontSize: 16)),
// // //             ),
// // //           )
// // //         ]),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:convert';

// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart'as http;
// // class FromTest extends StatefulWidget {
// //   const FromTest({super.key});
// //   @override
// //   State<FromTest> createState() => _ComplaintFormPageState();
// // }
// // class _ComplaintFormPageState extends State<FromTest> {
// //   final TextEditingController nameController = TextEditingController();
// //   final TextEditingController dateController = TextEditingController();
// //   final TextEditingController contactController = TextEditingController();
// //   final TextEditingController blockController = TextEditingController();
// //   final TextEditingController descriptionController = TextEditingController();
// //   String? selectedComplaintType;
// //   String? selectedTimeCarpentryCivil;
// //   String? selectedTimePlumbingElectrical;
// //   int complaintCounter = 11;
// //   String get complaintNumber => complaintCounter.toString().padLeft(4, '0');
// //   Future<void> handleSubmit() async {
// //     final Map<String, dynamic> complaintData = {
// //       'name': nameController.text,
// //       'date': dateController.text,
// //       'contact': contactController.text,
// //       'block': blockController.text,
// //       'complaintType': selectedComplaintType,
// //       'timeCarpentryCivil': selectedTimeCarpentryCivil,
// //       'timePlumbingElectrical': selectedTimePlumbingElectrical,
// //       'description': descriptionController.text,
// //       'complaintNumber': complaintNumber,
// //     };
// //     final response = await http.post(
// //       Uri.parse("http://192.168.0.23:3000/api/complaints"),
// //       headers: {'Content-Type': 'application/json'},
// //       body: json.encode(complaintData),
// //     );
// //     if (response.statusCode == 200 || response.statusCode == 201) {
// //       print("Success: ${response.body}");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Complaint submitted successfully!")),
// //       );
// //       setState(() {
// //         complaintCounter++;
// //         nameController.clear();
// //         dateController.clear();
// //         contactController.clear();
// //         blockController.clear();
// //         descriptionController.clear();
// //         selectedComplaintType = null;
// //         selectedTimeCarpentryCivil = null;
// //         selectedTimePlumbingElectrical = null;
// //       });
// //     } else {
// //       print("Failed: ${response.body}");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Submission failed")),
// //       );
// //     }
// //   }
// //   Widget buildRadioGroup(String title, List<String> options, String? selectedValue, Function(String?) onChanged) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //         ...options.map((option) => RadioListTile<String>(
// //               title: Text(option),
// //               value: option,
// //               groupValue: selectedValue,
// //               onChanged: onChanged,
// //             )),
// //       ],
// //     );
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Complaint Form'),
// //         backgroundColor: Colors.deepPurple,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text('Complaint Number: $complaintNumber', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 16),
// //             TextField(
// //               controller: nameController,
// //               decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
// //             ),
// //             const SizedBox(height: 12),
// //             TextField(
// //               controller: dateController,
// //               decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
// //             ),
// //             const SizedBox(height: 12),
// //             TextField(
// //               controller: contactController,
// //               keyboardType: TextInputType.phone,
// //               decoration: const InputDecoration(labelText: 'Contact', border: OutlineInputBorder()),
// //             ),
// //             const SizedBox(height: 12),
// //             TextField(
// //               controller: blockController,
// //               decoration: const InputDecoration(labelText: 'Block', border: OutlineInputBorder()),
// //             ),
// //             const SizedBox(height: 16),
// //             buildRadioGroup('Complaint Type', ['Carpentry', 'Civil', 'Plumbing', 'Electrical'],
// //                 selectedComplaintType, (value) {
// //               setState(() => selectedComplaintType = value);
// //             }),
// //             const SizedBox(height: 16),
// //             buildRadioGroup('Time Carpentry/Civil', ['Carpentry', 'Civil'], selectedTimeCarpentryCivil, (value) {
// //               setState(() => selectedTimeCarpentryCivil = value);
// //             }),
// //             const SizedBox(height: 16),
// //             buildRadioGroup('Time Plumbing/Electrical', ['Plumbing', 'Electrical'], selectedTimePlumbingElectrical,
// //                 (value) {
// //               setState(() => selectedTimePlumbingElectrical = value);
// //             }),
// //             const SizedBox(height: 16),
// //             TextField(
// //               controller: descriptionController,
// //               maxLines: 3,
// //               decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
// //             ),
// //             const SizedBox(height: 24),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 onPressed: handleSubmit,
// //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
// //                 child: const Text('Submit Complaint'),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class FromTest extends StatefulWidget {
//   const FromTest({super.key});

//   @override
//   State<FromTest> createState() => _ComplaintFormPageState();
// }

// class _ComplaintFormPageState extends State<FromTest> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController contactController = TextEditingController();
//   final TextEditingController blockController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();

//   String? selectedComplaintType;
//   String? selectedTimeCarpentryCivil;
//   String? selectedTimePlumbingElectrical;

//   int complaintCounter = 11;
//   String get complaintNumber => complaintCounter.toString().padLeft(4, '0');

//   Future<void> handleSubmit() async {
//     final Map<String, dynamic> complaintData = {
//       'name': nameController.text,
//       'date': dateController.text,
//       'contact': contactController.text,
//       'block': blockController.text,
//       'complaintType': selectedComplaintType,
//       'timeCarpentryCivil': selectedTimeCarpentryCivil,
//       'timePlumbingElectrical': selectedTimePlumbingElectrical,
//       'description': descriptionController.text,
//       'complaintNumber': complaintNumber,
//     };

//     try {
//       // ✅ For emulator use 10.0.2.2, for device use local IP like 192.168.x.x
//       final response = await http.post(
//         Uri.parse("http://10.0.2.2:3000/api/complaints"),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(complaintData),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print("Success: ${response.body}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Complaint submitted successfully!")),
//         );
//         setState(() {
//           complaintCounter++;
//           nameController.clear();
//           dateController.clear();
//           contactController.clear();
//           blockController.clear();
//           descriptionController.clear();
//           selectedComplaintType = null;
//           selectedTimeCarpentryCivil = null;
//           selectedTimePlumbingElectrical = null;
//         });
//       } else {
//         print("Failed: ${response.statusCode} - ${response.body}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Submission failed")),
//         );
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   Widget buildRadioGroup(String title, List<String> options, String? selectedValue, Function(String?) onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ...options.map((option) => RadioListTile<String>(
//               title: Text(option),
//               value: option,
//               groupValue: selectedValue,
//               onChanged: onChanged,
//             )),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Complaint Form'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Complaint Number: $complaintNumber',
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: dateController,
//               decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
//               readOnly: true,
//               onTap: () async {
//                 DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2023),
//                   lastDate: DateTime(2030),
//                 );
//                 if (picked != null) {
//                   dateController.text =
//                       '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
//                 }
//               },
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: contactController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(labelText: 'Contact', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: blockController,
//               decoration: const InputDecoration(labelText: 'Block', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 16),
//             buildRadioGroup(
//               'Complaint Type',
//               ['Carpentry', 'Civil', 'Plumbing', 'Electrical'],
//               selectedComplaintType,
//               (value) => setState(() => selectedComplaintType = value),
//             ),
//             const SizedBox(height: 16),
//             buildRadioGroup(
//               'Time Carpentry/Civil',
//               ['09:00 AM to 01:00 PM', '02:00 PM to 05:00 PM'],
//               selectedTimeCarpentryCivil,
//               (value) => setState(() => selectedTimeCarpentryCivil = value),
//             ),
//             const SizedBox(height: 16),
//             buildRadioGroup(
//               'Time Plumbing/Electrical',
//               ['09:00 AM to 01:00 PM', '02:00 PM to 05:00 PM', '05:00 PM to 07:00 PM'],
//               selectedTimePlumbingElectrical,
//               (value) => setState(() => selectedTimePlumbingElectrical = value),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: descriptionController,
//               maxLines: 3,
//               decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: handleSubmit,
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
//                 child: const Text('Submit Complaint'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';

// class TEstImage extends StatefulWidget {
//   @override
//   _TEstImageState createState() => _TEstImageState();
// }

// class _TEstImageState extends State<TEstImage> {
//   File? _imageFile;
//   final picker = ImagePicker();
//   bool _isUploading = false;
//   String? uploadedImageUrl;

//   Future<void> _openCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     } else {
//       print('No image selected.');
//     }
//   }

//   Future<void> _uploadPhoto() async {
//   if (_imageFile == null) return;

//   setState(() {
//     _isUploading = true;
//   });

//   try {
//     var uri = Uri.parse('https://ffb14a26e2ab.ngrok-free.app/api/complaints/endProcess/');
//     var request = http.MultipartRequest('POST', uri);

//     request.headers['Connection'] = 'close';

//     // Add the image file
//     var multipartFile = await http.MultipartFile.fromPath(
//       'file',
//       _imageFile!.path,
//     );
//     request.files.add(multipartFile);

//     // Send the request
//     var response = await request.send();

//     if (response.statusCode == 308) {
//       // Handle redirect
//       var newUrl = response.headers['location'];
//       if (newUrl != null) {
//         if (newUrl.startsWith('/')) {
//           newUrl = 'https://ffb14a26e2ab.ngrok-free.app$newUrl';
//         }
//         print('Redirected to $newUrl');

//         var redirectedRequest = http.MultipartRequest('POST', Uri.parse(newUrl));
//         redirectedRequest.headers['Connection'] = 'close';

//         // ❗ Recreate MultipartFile for redirected request
//         var newMultipartFile = await http.MultipartFile.fromPath(
//           'file',
//           _imageFile!.path,
//         );
//         redirectedRequest.files.add(newMultipartFile);

//         var redirectedResponse = await redirectedRequest.send();

//         if (redirectedResponse.statusCode == 200) {
//           String responseBody = await redirectedResponse.stream.bytesToString();
//           print('Upload success: $responseBody');
//           setState(() {
//             uploadedImageUrl = responseBody;
//           });
//         } else {
//           print('Redirected upload failed: ${redirectedResponse.reasonPhrase}');
//         }
//       }
//     } else if (response.statusCode == 200) {
//       String responseBody = await response.stream.bytesToString();
//       print('Upload success: $responseBody');
//       setState(() {
//         uploadedImageUrl = responseBody;
//       });
//     } else {
//       print('Upload failed: ${response.reasonPhrase}');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }

//   setState(() {
//     _isUploading = false;
//   });
// }

//   //   Future<void> _uploadPhoto() async {
//   //   if (_imageFile == null) return;

//   //   setState(() {
//   //     _isUploading = true;
//   //   });

//   //   var uri = Uri.parse('https://ffb14a26e2ab.ngrok-free.app/api/complaints/endProcess/');
//   //   var request = http.MultipartRequest('POST', uri);

//   //   request.headers['Connection'] = 'close';
//   //   request.headers['Accept'] = '*/*';

//   //   request.files.add(
//   //     await http.MultipartFile.fromPath(
//   //       'file',
//   //       _imageFile!.path,
//   //       filename: basename(_imageFile!.path),
//   //     ),
//   //   );

//   //   try {
//   //     var response = await request.send();

//   //     // Handle 308 redirect
//   //     if (response.statusCode == 308) {
//   //       var newUrl = response.headers['location'];
//   //       if (newUrl != null) {
//   //         print('Redirected to $newUrl');
//   //         var redirectedRequest = http.MultipartRequest('POST', Uri.parse(newUrl));
//   //         redirectedRequest.files.addAll(request.files);
//   //         redirectedRequest.headers.addAll(request.headers);
//   //         response = await redirectedRequest.send();
//   //       }
//   //     }

//   //     if (response.statusCode == 200) {
//   //       var responseData = await response.stream.bytesToString();
//   //       print('Upload success: $responseData');
//   //       setState(() {
//   //         uploadedImageUrl = responseData;
//   //       });
//   //     } else {
//   //       print('Upload failed: ${response.statusCode}');
//   //     }
//   //   } catch (e) {
//   //     print('Error: $e');
//   //   }

//   //   setState(() {
//   //     _isUploading = false;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Upload Photo')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             _imageFile != null
//                 ? Image.file(_imageFile!, height: 250)
//                 : Container(
//                     height: 250,
//                     color: Colors.grey[300],
//                     child: Center(child: Text('No image selected')),
//                   ),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _openCamera,
//               icon: Icon(Icons.camera_alt),
//               label: Text('Open Camera'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: _isUploading ? null : _uploadPhoto,
//               icon: Icon(Icons.upload),
//               label: _isUploading ? Text('Uploading...') : Text('Submit Photo'),
//             ),
//             SizedBox(height: 20),
//             uploadedImageUrl != null
//                 ? Text('Uploaded URL: $uploadedImageUrl')
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Ztext extends StatefulWidget {
  final int complaintId;
  const Ztext({super.key, required this.complaintId});

  @override
  State<Ztext> createState() => _ZtextState();
}

class _ZtextState extends State<Ztext> {
  File? _imageFile1;
  File? _imageFile2;
  String? _imageUrl1;
  String? _imageUrl2;
  final picker = ImagePicker();
  bool _isUploading = false;
  String? errorMessage;
  final TextEditingController _remarksController = TextEditingController();

  Future<void> _openCamera1() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _imageFile1 = File(pickedFile.path);
      debugPrint('📸 After photo selected: ${pickedFile.path}');
      _imageUrl1 = await uploadFileToServer(_imageFile1!);
      if (_imageUrl1 == null) {
        Get.showSnackbar(GetSnackBar(
          message: 'Failed to upload after photo. Try again.',
          duration: const Duration(seconds: 2),
        ));
      }
      setState(() {});
    } else {
      debugPrint('📸 No after photo selected.');
    }
  }

  Future<void> _openCamera2() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _imageFile2 = File(pickedFile.path);
      debugPrint('📸 Before photo selected: ${pickedFile.path}');
      _imageUrl2 = await uploadFileToServer(_imageFile2!);
      if (_imageUrl2 == null) {
        Get.showSnackbar(GetSnackBar(
          message: 'Failed to upload before photo. Try again.',
          duration: const Duration(seconds: 2),
        ));
      }
      setState(() {});
    } else {
      debugPrint('📸 No before photo selected.');
    }
  }

  Future<String?> uploadFileToServer(File file) async {
    final uri = Uri.parse('https://cd786942524f.ngrok-free.app/api/upload');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final url = data['url'];
        if (url != null && url is String) {
          debugPrint('✅ Uploaded file URL: $url');
          return url;
        } else {
          debugPrint('⚠️ No "url" in response: ${response.body}');
          return null;
        }
      } else {
        debugPrint('❌ Upload failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error during file upload: $e');
      return null;
    }
  }

  Future<void> _uploadPhoto() async {
    if (_imageUrl1 == null || _imageUrl2 == null) {
      Get.showSnackbar(GetSnackBar(
        message: 'Both photos must be uploaded before submitting.',
        duration: const Duration(seconds: 2),
      ));
      return;
    }

    setState(() {
      _isUploading = true;
      errorMessage = null;
    });

    debugPrint('📤 Submitting to API:');
    debugPrint('➡️ complaintId: ${widget.complaintId}');
    debugPrint('➡️ afterImage: $_imageUrl1');
    debugPrint('➡️ beforeImage: $_imageUrl2');

    try {
      final uri = Uri.parse(
          'https://cd786942524f.ngrok-free.app/api/complaints/endProcess/47');
      final request = http.Request('POST', uri);

      request.headers['Content-Type'] = 'application/json';
      request.body = json.encode({
        "beforeImage": _imageUrl2,
        "afterImage": _imageUrl1,
        "remarks": _remarksController.text.trim(),
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        debugPrint('✅ Upload success: $responseBody');
        Get.showSnackbar(GetSnackBar(
          message: 'Photos uploaded successfully!',
          duration: const Duration(seconds: 2),
        ));
      } else {
        debugPrint(
            '⚠️ Upload failed: ${response.statusCode} - ${response.reasonPhrase}');
        setState(() {
          errorMessage =
              'Upload failed: ${response.statusCode} ${response.reasonPhrase}';
        });
        Get.showSnackbar(GetSnackBar(
          message: errorMessage!,
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      debugPrint('❌ Upload error: $e');
      setState(() {
        errorMessage = 'Upload failed: $e';
      });
      Get.showSnackbar(GetSnackBar(
        message: errorMessage!,
        duration: const Duration(seconds: 2),
      ));
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Upload Photos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageFile1 == null)
                _buildCaptureButton("Capture After Photo", _openCamera1)
              else
                Image.file(_imageFile1!, height: 300),
              const SizedBox(height: 10),
              if (_imageFile2 == null)
                _buildCaptureButton("Capture Before Photo", _openCamera2)
              else
                Image.file(_imageFile2!, height: 300),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _remarksController,
                  decoration: const InputDecoration(
                    labelText: "Remarks (optional)",
                    border: OutlineInputBorder(),
                    hintText: "Enter remarks about the complaint resolution",
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: _isUploading ? null : _uploadPhoto,
                icon: const Icon(Icons.upload, color: Colors.white),
                label: _isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureButton(String text, VoidCallback onPressed) {
    return Column(
      children: [
        const Icon(Icons.add_a_photo, size: 80, color: Colors.grey),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
