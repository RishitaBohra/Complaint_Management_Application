


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/User/Presentation/UI/Home/Home.dart';
import 'package:amity_university/api_service_baseurl.dart';

class ComplaintFormPage extends StatefulWidget {
  const ComplaintFormPage({super.key});

  @override
  State<ComplaintFormPage> createState() => _ComplaintFormPageState();
}

class _ComplaintFormPageState extends State<ComplaintFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController blockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedComplaintType;
  String? selectedTimeCarpentryCivil;
  String? selectedTimePlumbingElectrical;

  int complaintCounter = 1;
  String get complaintNumber => complaintCounter.toString().padLeft(4, '0');

  bool submitted = false;
  bool isLoading = true; // loader at start
  bool formComplete = false;

  @override
  void initState() {
    super.initState();
    fetchComplaintCount();

    dateController.text =
        '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}';

    nameController.addListener(checkFormCompletion);
    contactController.addListener(checkFormCompletion);
    blockController.addListener(checkFormCompletion);
    descriptionController.addListener(checkFormCompletion);
  }

  Future<void> fetchComplaintCount() async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}api/complaints/"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List complaintList = data['data'];
        setState(() {
          complaintCounter = complaintList.length + 1;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() {
        isLoading = false; // loader off after fetch
      });
    }
  }

  bool isFieldEmpty(String text) => text.trim().isEmpty;

  void checkFormCompletion() {
    final complete = !isFieldEmpty(nameController.text) &&
        !isFieldEmpty(dateController.text) &&
        !isFieldEmpty(contactController.text) &&
        !isFieldEmpty(blockController.text) &&
        descriptionController.text.trim().length >= 50 &&
        selectedComplaintType != null &&
        contactController.text.trim().length == 10 &&
        !RegExp(r'[0-9]').hasMatch(nameController.text.trim()); // no numbers in name

    if (formComplete != complete) {
      setState(() {
        formComplete = complete;
      });
    }
  }

  Future<void> handleSubmit() async {
    setState(() {
      submitted = true;
      isLoading = true; // loader on during submission
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? token = prefs.getString('token');

    if (userId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to submit.")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (contactController.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact number must be exactly 10 digits.")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (descriptionController.text.trim().length < 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Description must be at least 50 characters.")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (RegExp(r'[0-9]').hasMatch(nameController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name cannot contain numbers.")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final complaintData = {
      'name': nameController.text.trim(),
      'date': dateController.text.trim(),
      'contact': contactController.text.trim(),
      'block': blockController.text.trim(),
      'complaintType': selectedComplaintType,
      'timeCarpentryCivil': selectedTimeCarpentryCivil,
      'timePlumbingElectrical': selectedTimePlumbingElectrical,
      'description': descriptionController.text.trim(),
      'complaintNumber': complaintNumber,
      'userId': userId,
    };

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}api/complaints"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(complaintData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Complaint submitted successfully")),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submission failed. Try again.")),
        );
      }
    } catch (e) {
      debugPrint("Submission error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error. Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false; // loader off after submission
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Technical Complaint Registration Form',
                style: TextStyle(fontSize: 18, color: Colors.white)),
            backgroundColor: ColorPicker.blueColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: ColorPicker.blueColor),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Please enter the below details correctly to lodge your maintenance related complaint.",
                        ),
                        const SizedBox(height: 8),
                        _buildComplaintNumberField(),
                        _buildTextField(
                          "1. Complainant Name *",
                          nameController,
                          hintText: 'Enter your name',
                          regexFilter: RegExp(r'[a-zA-Z\s]'),
                        ),
                        _buildDateField(
                          "2. Date *",
                          dateController,
                        ),
                        _buildContactField(),
                        _buildTextField(
                          "4. Block/Flat/Office Number *",
                          blockController,
                          hintText: 'Enter your Address',
                          regexFilter: RegExp(r'[a-zA-Z0-9\s]'),
                        ),
                        _buildRadioGroup(
                          "5. Complaint Type *",
                          ["Plumbing", "Electrical", "Carpentry", "Civil", "Other"],
                          selectedComplaintType,
                          (val) {
                            setState(() {
                              selectedComplaintType = val;
                              selectedTimeCarpentryCivil = null;
                              selectedTimePlumbingElectrical = null;
                            });
                            checkFormCompletion();
                          },
                        ),
                        if (selectedComplaintType == "Carpentry" ||
                            selectedComplaintType == "Civil")
                          _buildRadioGroup(
                            "6. Preferred Time for Carpentry/Civil",
                            ["09:00 AM to 01:00 PM", "02:00 PM to 05:00 PM"],
                            selectedTimeCarpentryCivil,
                            (val) => setState(() => selectedTimeCarpentryCivil = val),
                          ),
                        if (selectedComplaintType == "Plumbing" ||
                            selectedComplaintType == "Electrical")
                          _buildRadioGroup(
                            "7. Preferred Time for Plumbing and Electrical",
                            [
                              "09:00 AM to 01:00 PM",
                              "02:00 PM to 05:00 PM",
                              "05:00 PM to 07:00 PM"
                            ],
                            selectedTimePlumbingElectrical,
                            (val) =>
                                setState(() => selectedTimePlumbingElectrical = val),
                          ),
                        _buildDescriptionField(),
                        const SizedBox(height: 25),
                        Opacity(
                          opacity: formComplete ? 1.0 : 0.5,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: formComplete ? handleSubmit : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPicker.blueColor,
                              ),
                              child: const Text("Submit",
                                  style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildContactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          "3. Contact Number *",
          contactController,
          isPhone: true,
          hintText: 'Enter your contact number',
          maxLength: 10,
        ),
        if (contactController.text.trim().length != 10 &&
            contactController.text.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 10),
            child: Text(
              "Enter 10 digits",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("8. Description *",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: descriptionController,
          maxLines: 4,
          minLines: 3,
          maxLength: 500,
          decoration: const InputDecoration(
            hintText: "Enter at least 50 characters",
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => checkFormCompletion(),
        ),
        if (descriptionController.text.trim().length < 50 &&
            descriptionController.text.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 10),
            child: Text(
              "Description must be at least 50 characters.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: const InputDecoration(
            hintText: 'dd-mm-yyyy',
            suffixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
            );
            if (pickedDate != null) {
              controller.text =
                  '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
              checkFormCompletion();
            }
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildRadioGroup(String title, List<String> options,
      String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Column(
          children: options
              .map((option) => RadioListTile<String>(
                    value: option,
                    groupValue: selectedValue,
                    onChanged: (val) {
                      onChanged(val);
                      checkFormCompletion();
                    },
                    title: Text(option),
                    dense: true,
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                  ))
              .toList(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPhone = false,
      required String hintText,
      bool digitsOnly = false,
      RegExp? regexFilter,
      int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: isPhone || digitsOnly
              ? TextInputType.number
              : TextInputType.text,
          inputFormatters: [
            if (regexFilter != null)
              FilteringTextInputFormatter.allow(regexFilter),
            if (isPhone) FilteringTextInputFormatter.digitsOnly,
          ],
          maxLength: maxLength,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildComplaintNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Complaint Number",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          readOnly: true,
          controller: TextEditingController(text: complaintNumber),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
