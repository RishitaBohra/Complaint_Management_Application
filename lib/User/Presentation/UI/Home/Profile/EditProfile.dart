




// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final addressController = TextEditingController();
//   bool isLoading = true;
//   int? userId;
//   File? _selectedImage;
//   String? _currentImageUrl; // Holds the current image URL from API
//   final picker = ImagePicker();
//   bool _isUploading = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchProfile();
//   }

//   Future<void> fetchProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getInt('userId') ?? 1;

//     final String profileApi =
//         "http://192.168.0.7:3000/api/front/profile?id=$userId";

//     try {
//       final response = await http.get(Uri.parse(profileApi), headers: {
//         'Content-Type': 'application/json',
//       });

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         debugPrint("✅ Profile fetched: $data");
//         setState(() {
//           nameController.text = data['name'] ?? '';
//           emailController.text = data['email'] ?? '';
//           addressController.text = data['address'] ?? '';
//           _currentImageUrl = data['image'];
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

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _uploadProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isUploading = true;
//     });

//     final String updateApi =
//         "http://192.168.0.7:3000/api/front/profile?id=$userId";

//     var request = http.MultipartRequest('PUT', Uri.parse(updateApi));

//     request.fields['name'] = nameController.text;
//     request.fields['email'] = emailController.text;
//     request.fields['address'] = addressController.text;

//     if (_selectedImage != null) {
//       var multipartFile = await http.MultipartFile.fromPath(
//         'image',
//         _selectedImage!.path,
//       );
//       request.files.add(multipartFile);
//     }

//     debugPrint('➡️ Uploading to: ${request.url}');
//     debugPrint('📂 Files: ${request.files}');
//     debugPrint('📝 Fields: ${request.fields}');

//     try {
//       var response = await request.send();
//       String responseBody = await response.stream.bytesToString();
//       debugPrint('📥 Server response: $responseBody');

//       if (response.statusCode == 200) {
//         debugPrint("✅ Profile updated successfully");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Profile updated successfully")),
//         );
//         Navigator.pop(context, true);
//       } else {
//         debugPrint("❌ Update failed: ${response.statusCode}");
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
//       _isUploading = false;
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
//                       child: GestureDetector(
//                         onTap: _pickImage,
//                         child: Stack(
//                           alignment: Alignment.bottomRight,
//                           children: [
//                             CircleAvatar(
//                               radius: 60,
//                               backgroundImage: _selectedImage != null
//                                   ? FileImage(_selectedImage!)
//                                   : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
//                                       ? NetworkImage(_currentImageUrl!)
//                                       : const AssetImage('assets/logo.png')
//                                     ) as ImageProvider,
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.black54,
//                               ),
//                               padding: const EdgeInsets.all(6),
//                               child: const Icon(
//                                 Icons.edit,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildField("Name", nameController),
//                     _buildField("Email", emailController),
//                     _buildField("Address", addressController),
//                     const SizedBox(height: 30),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorPicker.blueColor,
//                       ),
//                       onPressed: _isUploading ? null : _uploadProfile,
//                       child: _isUploading
//                           ? const CircularProgressIndicator(
//                               color: Colors.white, strokeWidth: 2)
//                           : const Text(
//                               "Save Changes",
//                               style: TextStyle(color: Colors.white),
//                             ),
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
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/api_service_baseurl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  bool isLoading = true;
  int? userId;
  File? _selectedImage;
  String? _currentImageUrl;
  final picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 1;

    final String profileApi =
        "${baseUrl}api/front/profile?id=$userId"; 

    try {
      final response = await http.get(Uri.parse(profileApi));

      debugPrint('📥 Fetch response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint("✅ Profile fetched: $data");

        setState(() {
          nameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          addressController.text = data['address'] ?? '';
          if (data['image'] != null && data['image'].toString().isNotEmpty) {
            _currentImageUrl = "${baseUrl}${data['image']}";
          } else {
            _currentImageUrl = null;
          }
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

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isUploading = true;
    });

    final String updateApi =
        "${baseUrl}api/front/profile?id=$userId";

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "name": nameController.text,
      "email": emailController.text,
      "address": addressController.text,
    });

    try {
      final response = await http.put(
        Uri.parse(updateApi),
        headers: headers,
        body: body,
      );

      debugPrint('📥 Update response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        Navigator.pop(context, true);
      } else {
        debugPrint(
            "❌ Update failed: ${response.statusCode} ${response.reasonPhrase}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update failed: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      debugPrint("❌ Error uploading profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error updating profile")),
      );
    }

    setState(() {
      _isUploading = false;
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
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : (_currentImageUrl != null
                                      ? NetworkImage(_currentImageUrl!)
                                      : const AssetImage('assets/logo.png')
                                    ) as ImageProvider,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black54,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildField("Name", nameController),
                    _buildField("Email", emailController),
                    _buildField("Address", addressController),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPicker.blueColor,
                      ),
                      onPressed: _isUploading ? null : _uploadProfile,
                      child: _isUploading
                          ? const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)
                          : const Text(
                              "Save Changes",
                              style: TextStyle(color: Colors.white),
                            ),
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
