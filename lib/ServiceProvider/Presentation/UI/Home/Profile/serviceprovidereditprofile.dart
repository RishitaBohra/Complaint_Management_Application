
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
// import 'package:amity_university/api_service_baseurl.dart';

// class ServiceProviderEditProfileScreen extends StatefulWidget {
//   const ServiceProviderEditProfileScreen({super.key});

//   @override
//   State<ServiceProviderEditProfileScreen> createState() =>
//       _ServiceProviderEditProfileScreenState();
// }

// class _ServiceProviderEditProfileScreenState
//     extends State<ServiceProviderEditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final contactController = TextEditingController();
//   final statusController = TextEditingController();

//   bool isLoading = true;
//   bool isUploading = false;

//   int? staffId;
//   String? token;
//   String? _currentImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     fetchProfile();
//   }

//   Future<void> fetchProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     staffId = prefs.getInt('staffId');
//     token = prefs.getString('token');

//     if (staffId == null || token == null) {
//       debugPrint("❌ No staffId or token found.");
//       setState(() => isLoading = false);
//       return;
//     }

//     final String profileApi = "${baseUrl}api/front/profile-staff/$staffId";

//     try {
//       final response = await http.get(Uri.parse(profileApi), headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       });

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         debugPrint("✅ Profile fetched: $data");

//         setState(() {
//           nameController.text = data['data']['name'] ?? '';
//           contactController.text = data['data']['contact'] ?? '';
//           statusController.text = data['data']['status'] ?? '';
//           _currentImageUrl = data['data']['image'] != null
//               ? "${baseUrl}${data['data']['image']}"
//               : null;
//           isLoading = false;
//         });
//       } else {
//         debugPrint("❌ Fetch failed: ${response.statusCode}");
//         setState(() => isLoading = false);
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching profile: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> updateProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       isUploading = true;
//     });

//     String updateApi = "${baseUrl}api/front/profile-staff/$staffId";
//     debugPrint("📡 API: $updateApi");
//     debugPrint("🪪 Token: $token");

//     try {
//       final response = await http.put(
//         Uri.parse(updateApi),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode({
//           "name": nameController.text,
//           "contact": contactController.text,
//           "status": statusController.text,
//         }),
//       );

//       debugPrint("📥 Update response: ${response.statusCode}");
//       debugPrint("📦 Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['success'] == true) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(jsonResponse['message'] ?? "Profile updated")),
//           );
//           Navigator.pop(context, true);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(jsonResponse['message'] ?? "Update failed")),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Update failed: ${response.statusCode}")),
//         );
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating profile: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Error updating profile")),
//       );
//     }

//     setState(() {
//       isUploading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
//         backgroundColor: ColorPicker.blueColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     Center(
//                       child: Stack(
//                         alignment: Alignment.bottomRight,
//                         children: [
//                           CircleAvatar(
//                             radius: 60,
//                             backgroundImage: _currentImageUrl != null
//                                 ? NetworkImage(_currentImageUrl!)
//                                 : const AssetImage('assets/logo.png')
//                                     as ImageProvider,
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.black54,
//                             ),
//                             padding: const EdgeInsets.all(6),
//                             child: const Icon(
//                               Icons.camera_alt,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildField("Name", nameController),
//                     _buildField("Contact", contactController),
//                     _buildField("Status", statusController),
//                     const SizedBox(height: 30),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorPicker.blueColor,
//                       ),
//                       onPressed: isUploading ? null : updateProfile,
//                       child: isUploading
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : const Text("Save Changes",
//                               style: TextStyle(color: Colors.white)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         validator: (value) =>
//             value == null || value.isEmpty ? "Required" : null,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/api_service_baseurl.dart';

class ServiceProviderEditProfileScreen extends StatefulWidget {
  const ServiceProviderEditProfileScreen({super.key});

  @override
  State<ServiceProviderEditProfileScreen> createState() =>
      _ServiceProviderEditProfileScreenState();
}

class _ServiceProviderEditProfileScreenState
    extends State<ServiceProviderEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final statusController = TextEditingController();

  bool isLoading = true;
  bool isUploading = false;

  int? staffId;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    staffId = prefs.getInt('staffId');
    token = prefs.getString('token');

    if (staffId == null || token == null) {
      debugPrint("❌ No staffId or token found.");
      setState(() => isLoading = false);
      return;
    }

    final String profileApi = "${baseUrl}api/front/profile-staff/$staffId";

    try {
      final response = await http.get(Uri.parse(profileApi), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint("✅ Profile fetched: $data");

        setState(() {
          nameController.text = data['data']['name'] ?? '';
          contactController.text = data['data']['contact'] ?? '';
          statusController.text = data['data']['status'] ?? '';
          isLoading = false;
        });
      } else {
        debugPrint("❌ Fetch failed: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("❌ Error fetching profile: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isUploading = true;
    });

    String updateApi = "${baseUrl}api/front/profile-staff/$staffId";
    debugPrint("📡 API: $updateApi");
    debugPrint("🪪 Token: $token");

    try {
      final response = await http.put(
        Uri.parse(updateApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': nameController.text,
          'contact': contactController.text,
          'status': statusController.text,
        }),
      );

      debugPrint("📥 Update response: ${response.statusCode}");
      debugPrint("📦 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          // ✅ Update staffName in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('staffName', nameController.text);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? "Profile updated")),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? "Update failed")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("❌ Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error updating profile")),
      );
    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: ColorPicker.blueColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    _buildField("Name", nameController),
                    _buildField("Contact", contactController),
                    _buildField("Status", statusController),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPicker.blueColor,
                      ),
                      onPressed: isUploading ? null : updateProfile,
                      child: isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Save Changes",
                              style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: (value) =>
            value == null || value.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
